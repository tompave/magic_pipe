module MagicPipe
  module Codecs
    class Base
      TYPE = "none"

      # object should be something similar
      # to an ActiveModel::Serializer or
      # ActiveRecord object.
      #
      def initialize(object)
        @object = object
      end

      attr_reader :object
      alias_method :o, :object

      def encode
        raise NotImplementedError
      end

      def type
        self.class.const_get(:TYPE)
      end
    end
  end
end
