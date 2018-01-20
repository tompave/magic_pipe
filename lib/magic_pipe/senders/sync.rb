require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        payload = @codec.new(@data).encode
        @transport.submit(payload)
      end
    end
  end
end
