RSpec.describe MagicPipe::Transports::Sqs do
  let(:config) do
    MagicPipe::Config.new do |c|
      c.codec = :yaml
      c.transport = :sqs

      c.sqs_transport_options = {
        queue: "test_queue"
      }
    end
  end
  let(:queue_url) { "https://fake.sqs.url/test_queue" }

  let(:metrics) { MagicPipe::Metrics.new(config) }
  let(:aws_client) { instance_double(Aws::SQS::Client) }

  subject { described_class.new(config, metrics) }

  before do
    allow(aws_client).to receive(:get_queue_url).with(
      queue_name: "test_queue"
    ).and_return(
      double(
        "AWS API response",
        queue_url: queue_url
      )
    )

    allow(Aws::SQS::Client).to receive(:new).and_return(aws_client)
  end


  describe "#submit" do
    let(:payload) { "an encoded payload" }
    let(:metadata) do
      {
        topic: "marsupials",
        producer: "Mr. Koala",
        time: 123123123,
        mime: "foobar"
      }
    end

    def perform
      subject.submit(payload, metadata)
    end

    it "publishes a message to SQS with the correct data" do
      expect(aws_client).to receive(:send_message).with(
        {
          queue_url: queue_url,
          message_body: payload,
          delay_seconds: 0,
          message_attributes: {
            "topic" => {
              string_value: "marsupials",
              data_type: "String",
            },
            "producer" => {
              string_value: "Mr. Koala",
              data_type: "String",
            },
            "sent_at" => {
              string_value: "123123123",
              data_type: "Number",
            },
            "mime" => {
              string_value: "foobar",
              data_type: "String",
            },
          }
        }
      )

      perform
    end
  end
end
