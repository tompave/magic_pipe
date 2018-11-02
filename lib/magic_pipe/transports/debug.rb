require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Debug < Base
      def initialize(*)
      end

      def submit!(payload, metadata)
        $magic_pipe_out = {
          payload: payload,
          metadata: metadata
        }
      end
    end
  end
end
