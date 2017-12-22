module MagicPipe
  module Senders
    class Base
      # object should be something similar
      # to an ActiveModel::Serializer or
      # ActiveRecord object.
      #
      def initialize(data, codec, transport)
        @data = data
        @codec = codec
        @transport = transport
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
