module MagicPipe
  module Codecs
    class Base
      ENCODING = "none"

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

      def encoding
        self.class.const_get(:ENCODING)
      end
    end
  end
end
