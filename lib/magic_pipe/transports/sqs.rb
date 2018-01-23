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
      end


      def submit(payload, metadata)
        send_message(payload, metadata)
      end


      def queue_name
        @options.fetch(:queue_name, "magic_pipe_sandbox")
      end

      def queue_url
        @queue_url ||= @client.get_queue_url(queue_name: queue_name).queue_url
      end


      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html#send_message-instance_method
      def send_message(payload, metadata)
        @client.send_message({
          queue_url: queue_url, # required
          message_body: payload, # required
          # delay_seconds: 0,
          message_attributes: {
            "topic" => {
              string_value: metadata[:topic],
              data_type: "String", # required
            },
            "producer" => {
              string_value: metadata[:producer],
              data_type: "String", # required
            },
            "sent_at" => {
              string_value: metadata[:time],
              data_type: "Number", # required
            },
          }
        })
      end


      # def receive_message
      #   @client.receive_message(
      #     queue_url: queue_url,
      #     attribute_names: ["All"],
      #     message_attribute_names: ["All"],
      #     # visibility_timeout: 0
      #   )
      # end


      # def delete_message(handle)
      #   @client.delete_message(
      #     queue_url: queue_url,
      #     receipt_handle: handle
      #   )
      # end
    end
  end
end
