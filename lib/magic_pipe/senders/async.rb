require 'sidekiq'
require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Async < Base
      class Worker
        include Sidekiq::Worker

        def perform(decomposed_object, topic, time, client_name)
          client = MagicPipe.lookup_client(client_name)
          object = client.loader.load(decomposed_object)
          codec = client.codec

          metadata = {
            topic: topic,
            producer: client.config.producer_name,
            time: time.to_i,
            mime: codec::TYPE
          }

          envelope = Envelope.new(
            body: object,
            **metadata
          )

          payload = codec.new(envelope).encode
          client.transport.submit(payload, metadata)
        end
      end


      SETTINGS = {
        "class" => Worker,
        "queue" => "magic_pipe",
        "retry" => true
      }

      def call
        enqueue
      end

      def enqueue
        options = SETTINGS.merge({
          "args" => [
            decomposed_object,
            @topic,
            @time,
            @config.client_name
          ]
        })
        Sidekiq::Client.push(options)
      end


      def decomposed_object
        loader = MagicPipe::Loaders.lookup(@config.loader)
        loader.new(@object, @wrapper).decompose
      end
    end
  end
end
