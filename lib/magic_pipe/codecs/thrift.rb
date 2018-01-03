require "magic_pipe/codecs/base"

module MagicPipe
  module Codecs
    class Thrift < Base

      def encoding
        :thrift
      end
    end
  end
end
