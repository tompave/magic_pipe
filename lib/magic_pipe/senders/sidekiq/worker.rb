require 'sidekiq'

module MagicPipe
  module Senders
    class Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(args)
          data = args["data"]
          codec = args["codec"]
          transport = args["transport"]

          payload = codec.new(data).encode
          transport.new(payload).submit
        end
      end
    end
  end
end
