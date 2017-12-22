require 'sidekiq'
require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Sidekiq < Base
      SETTINGS = {
        "class" => Worker,
        "queue" => "magic_pipe",
      }

      def call
        enqueue
      end

      def enqueue
        options = SETTINGS.merge({
          "args" => {
            "data" => @data,
            "codec" => @codec,
            "transport" => @transport,
          }
        })
        ::Sidekiq::Client.push(options)
      end
    end
  end
end
