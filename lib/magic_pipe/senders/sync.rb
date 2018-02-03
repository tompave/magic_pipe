require "magic_pipe/senders/base"
require "magic_pipe/senders/metrics_mixin"

module MagicPipe
  module Senders
    class Sync < Base
      include MetricsMixin

      def call
        metadata = build_metadata
        envelope = build_message(metadata)
        payload = @codec.new(envelope).encode
        @transport.submit(payload, metadata)
        track_success(@metrics, @topic)
      rescue => e
        track_failure(@metrics, @topic)
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
    end
  end
end
