module MagicPipe
  module Senders
    module MetricsMixin
      def track_success(metrics, topic)
        metrics.increment(
          "magic_pipe.senders.mgs_sent",
          tags: ["topic:#{topic}"]
        )
      end

      def track_failure(metrics, topic)
        metrics.increment(
          "magic_pipe.senders.failure",
          tags: ["topic:#{topic}"]
        )
      end

    end
  end
end
