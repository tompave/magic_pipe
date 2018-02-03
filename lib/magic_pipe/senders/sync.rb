require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        metadata = build_metadata
        envelope = build_message(metadata)
        payload = @codec.new(envelope).encode
        @transport.submit(payload, metadata)
        track_success
      rescue => e
        track_failure
        raise e
      end

      def build_message(metadata)
        Envelope.new(body: data, **metadata)
      end

      def build_metadata
        {
          topic: @topic,
          producer: @config.producer_name,
          time: @time.to_i,
          mime: @codec::TYPE
        }
      end

      def data
        @wrapper ? @wrapper.new(@object) : @object
      end

      def track_success
        @metrics.increment(
          "magic_pipe.senders.sync.mgs_sent",
          tags: ["topic:#{@topic}"]
        )
      end

      def track_failure
        @metrics.increment(
          "magic_pipe.senders.sync.failure",
          tags: ["topic:#{@topic}"]
        )
      end
    end
  end
end
