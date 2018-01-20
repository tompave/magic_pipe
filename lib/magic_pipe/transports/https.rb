require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Https < Base
      def initialize(config, metrics)
        super(config, metrics)
        @conn = build_connection
      end

      def submit(payload)
        @conn.post("/") do |r|
          r.body = @payload
        end
      end


      private


      # For a single backend, can't this be cached as a read only global?
      #
      def build_connection


        # faraday object
        # the backend URL goes there

        # also set the encoding!
      end

      def encoding
        @encoding ||= MagicPipe::Codecs.lookup(@config.codec)::ENCODING
      end
    end
  end
end
