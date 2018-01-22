module MagicPipe
  module Senders
    class Base
      # object should be something similar
      # to an ActiveModel::Serializer or
      # ActiveRecord object.
      #
      def initialize(object, topic, wrapper, time, codec, transport, config)
        @object = object
        @topic = topic
        @wrapper = wrapper
        @time = time
        @codec = codec
        @transport = transport
        @config = config
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
