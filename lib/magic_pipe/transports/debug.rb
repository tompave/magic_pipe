require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Debug < Base
      def initialize(*)
      end

      def submit(payload)
        $magic_pipe_out = payload
      end
    end
  end
end
