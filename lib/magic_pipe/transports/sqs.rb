require "magic_pipe/transports/base"

require "aws-sdk-sqs"

# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS.html
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html

module MagicPipe
  module Transports
    class Sqs < Base
      def initialize(config, metrics)
        super(config, metrics)
        @options = @config.sqs_transport_options
        @client = Aws::SQS::Client.new
        @name = "sqs"
      end

      attr_reader :name


      def do_submit(payload, metadata)
        send_message(payload, metadata)
      end


      private


      def queue_name
        @options.fetch(:queue)
      end


      def queue_url
        @queue_url ||= @client.get_queue_url(queue_name: queue_name).queue_url
      end


      def send_message(payload, metadata)
        @client.send_message({
          queue_url: queue_url, # required
          message_body: payload, # required
          delay_seconds: 0,
          message_attributes: meta_attributes(metadata)
        })
      end


      def meta_attributes(metadata)
        {
          "topic" => {
            string_value: metadata[:topic],
            data_type: "String", # required
          },
          "producer" => {
            string_value: metadata[:producer],
            data_type: "String", # required
          },
          "sent_at" => {
            string_value: metadata[:time].to_s,
            data_type: "Number", # required
          },
          "mime" => {
            string_value: metadata[:mime],
            data_type: "String", # required
          },
        }
      end
    end
  end
end
