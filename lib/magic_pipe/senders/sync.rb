require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        payload = @codec.new(@data).encode
        @transport.new(payload, @codec.encoding).submit
      end
    end
  end
end
