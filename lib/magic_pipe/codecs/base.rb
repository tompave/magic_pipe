module MagicPipe
  module Codecs
    class Base
      TYPE = "none"

      # object should be something similar
      # to an ActiveModel::Serializer or
      # ActiveRecord object.
      #
      def initialize(envelope)
        @envelope = envelope
      end

      attr_reader :envelope
      alias_method :object, :envelope
      alias_method :o, :envelope

      def encode
        raise NotImplementedError
      end

      def inner_object
        @envelope.body
      end

      def type
        self.class.const_get(:TYPE)
      end
    end
  end
end
