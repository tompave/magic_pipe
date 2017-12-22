require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Synchronous < Base
      def call
        payload = @codec.new(@data).encode
        @transport.new(payload).submit
      end
    end
  end
end
