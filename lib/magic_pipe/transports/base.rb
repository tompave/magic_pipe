module MagicPipe
  module Transports
    class Base
      def initialize(config, metrics)
        @config = config
        @metrics = metrics
        @logger = @config.logger
      end

      attr_reader :metrics, :logger

      def submit(payload)
        raise NotImplementedError
      end
    end
  end
end
