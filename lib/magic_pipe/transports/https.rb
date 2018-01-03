require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Https < Base
      def submit
        connection.post("/") do |r|
          r.body = @payload
        end
      end

      # For a single backend, can't this be cached as a read only global?
      #
      def connection
        # faraday object
        # the backend URL goes there

        # also set the encoding!
      end
    end
  end
end
