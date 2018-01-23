require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        payload = @codec.new(message).encode
        @transport.submit(payload)
      end

      def message
        Envelope.new(
          body: data,
          topic: @topic,
          producer: @config.producer_name,
          time: @time,
          mime: @codec::TYPE
        )
      end

      def data
        @wrapper ? @wrapper.new(@object) : @object
      end
    end
  end
end
