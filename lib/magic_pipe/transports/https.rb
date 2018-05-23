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
        @path_builder = @options[:dynamic_path_builder]
      end

      attr_reader :conn


      # TODO: should this raise an error on failure?
      # So that it can be retried?
      #
      def submit(payload, metadata)
        username, password = basic_auth(metadata[:topic])
        @conn.basic_auth(username, password || "x")
        @conn.post do |r|
          path = dynamic_path(metadata[:topic])
          r.url(path) if path

          r.body = payload
          r.headers["X-MagicPipe-Sent-At"] = metadata[:time]
          r.headers["X-MagicPipe-Topic"] = metadata[:topic]
          r.headers["X-MagicPipe-Producer"] = metadata[:producer]
        end
      end


      private


      def dynamic_path(topic)
        return nil unless !!@path_builder
        @path_builder.call(topic)
      end

      def url
        @options.fetch(:url)
      end

      def basic_auth(topic)
        user_auth = @options.fetch(:basic_auth)
        credentials = if user_auth.respond_to?(:call)
          user_auth.call(topic)
        else
          user_auth
        end
        credentials.split(':')
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
