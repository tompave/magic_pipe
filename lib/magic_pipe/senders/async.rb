require 'sidekiq'
require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Async < Base
      class Worker
        include Sidekiq::Worker

        def perform(args)
          data = args["data"]
          codec = args["codec"]
          transport = args["transport"]

          payload = codec.new(data).encode
          transport.new(payload, codec.encoding).submit
        end
      end


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
        Sidekiq::Client.push(options)
      end
    end
  end
end
