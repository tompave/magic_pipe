require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Https < Base
      def initialize(metrics, logger)
        super(metrics, logger)
        @conn = build_connection
      end

      def submit(payload, encoding)
        @conn.post("/") do |r|
          r.body = @payload
        end
      end

      # For a single backend, can't this be cached as a read only global?
      #
      def build_connection
        # faraday object
        # the backend URL goes there

        # also set the encoding!
      end
    end
  end
end
