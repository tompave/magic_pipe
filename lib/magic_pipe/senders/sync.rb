require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        metadata = build_metadata
        envelope = build_message(metadata)
        payload = @codec.new(envelope).encode
        @transport.submit(payload, metadata)
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
