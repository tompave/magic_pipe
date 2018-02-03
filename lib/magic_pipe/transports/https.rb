require "magic_pipe/transports/base"

require "faraday"
require "typhoeus"
require "typhoeus/adapters/faraday"

module MagicPipe
  module Transports
    class Https < Base
      def initialize(config, metrics)
        super(config, metrics)
        @options = @config.https_transport_options
        @conn = build_connection
        @name = "https"
      end

      attr_reader :conn, :name


      def do_submit(payload, metadata)
        response = @conn.post do |r|
          r.body = payload
          r.headers["X-MagicPipe-Sent-At"] = metadata[:time]
          r.headers["X-MagicPipe-Topic"] = metadata[:topic]
          r.headers["X-MagicPipe-Producer"] = metadata[:producer]
        end

        response.success?
      end


      private

      def url
        @options.fetch(:url)
      end

      def auth_token
        @options.fetch(:auth_token)
      end

      def timeout
        @options.fetch(:timeout)
      end

      def open_timeout
        @options.fetch(:open_timeout)
      end

      def content_type
        MagicPipe::Codecs.lookup(@config.codec)::TYPE
      end

      def user_agent
        "MagicPipe v%s (Faraday v%s, Typhoeus v%s)" % [
          MagicPipe::VERSION,
          Faraday::VERSION,
          Typhoeus::VERSION
        ]
      end

      # For a single backend, can't this be cached as a read only global?
      #
      def build_connection
        Faraday.new(url) do |f|
          f.request :retry, max: 2, interval: 0.1, backoff_factor: 2
          f.request :basic_auth, auth_token, 'x'

          f.headers['Content-Type'] = content_type
          f.headers['User-Agent'] = user_agent

          f.options.timeout = timeout
          f.options.open_timeout = open_timeout

          f.adapter :typhoeus
        end
      end
    end
  end
end
