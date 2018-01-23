require 'sidekiq'
require "magic_pipe/senders/base"

module MagicPipe
  module Senders
    class Async < Base
      class Worker
        include Sidekiq::Worker

        def perform(decomposed_object, topic, time, client_name)
          client = MagicPipe.lookup_client(client_name)
          codec = client.codec
          transport = client.transport

          object = load_object(decomposed_object, client.loader)

          producer_name = client.config.producer_name

          metadata = {
            topic: topic,
            producer: producer_name,
            time: time.to_i,
            mime: codec::TYPE
          }
          envelope = Envelope.new(
            body: object,
            **metadata
          )

          payload = codec.new(envelope).encode
          transport.submit(payload, metadata)
        end


        def load_object(data, loader)
          loader.load(
            data["klass"],
            data["id"],
            data["wrapper"]
          )
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
