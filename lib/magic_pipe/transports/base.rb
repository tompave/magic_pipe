module MagicPipe
  module Transports
    class Base
      def initialize(metrics, logger)
        @metrics = metrics
        @logger = logger
      end

      attr_reader :metrics, :logger

      def submit(payload, encoding)
        raise NotImplementedError
      end
    end
  end
end
