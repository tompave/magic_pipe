require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Log < Base
      def initialize(config, metrics)
        super(config, metrics)
      end

      def submit(payload)
        @logger.info "[Trasport#submit]: ↩️\n#{payload}\n"
      end
    end
  end
end
