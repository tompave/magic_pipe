require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Sqs < Base
      def initialize(config, metrics)
        super(config, metrics)
        # @options = @config.sqs_transport_options
      end

      def submit(payload)
      end
    end
  end
end
