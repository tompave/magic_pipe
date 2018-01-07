require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sync < Base
      def call
        encoder = @codec.new(@data)
        payload = encoder.encode
        @transport.submit(payload, encoder.encoding)
      end
    end
  end
end
