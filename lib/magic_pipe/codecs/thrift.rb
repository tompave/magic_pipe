require "magic_pipe/codecs/base"

module MagicPipe
  module Codecs
    class Thrift < Base
      # application/vnd.apache.thrift.binary
      # application/vnd.apache.thrift.compact
      # application/vnd.apache.thrift.json

      TYPE = "application/vnd.apache.thrift.binary"

      def encode
        "not implemented"
      end
    end
  end
end
