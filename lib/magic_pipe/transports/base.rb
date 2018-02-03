module MagicPipe
  module Transports
    class Base
      def initialize(config, metrics)
        @config = config
        @metrics = metrics
        @logger = @config.logger
      end

      attr_reader :metrics, :logger

      # TODO: should this always raise errors on failure?
      # So that it can be retried?
      #
      def submit(payload, metadata)
        if do_submit(payload, metadata)
          track_success(metadata[:topic])
          true
        else
          track_failure(metadata[:topic])
          false
        end
      rescue => e
        track_failure(metadata[:topic])
        raise e
      end

      def do_submit(payload, metadata)
        raise NotImplementedError
      end

      def name
        raise NotImplementedError
      end

      def track_success(topic)
        @metrics.increment(
          "magic_pipe.transports.submit_ok",
          tags: [
            "topic:#{topic}",
            "transport:#{name}",
          ]
        )
      end

      def track_failure(topic)
        @metrics.increment(
          "magic_pipe.transports.submit_failure",
          tags: [
            "topic:#{topic}",
            "transport:#{name}",
          ]
        )
      end
    end
  end
end
