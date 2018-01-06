require "magic_pipe/codecs/base"

module MagicPipe
  module Codecs
    class Thrift < Base
      def encode
        "not implemented"
      end

      def encoding
        :thrift
      end
    end
  end
end
