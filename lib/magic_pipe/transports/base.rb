module MagicPipe
  module Transports
    class Base
      def initialize(payload, encoding)
        @payload = payload
        @encoding = encoding
      end

      def submit
        raise NotImplementedError
      end
    end
  end
end
