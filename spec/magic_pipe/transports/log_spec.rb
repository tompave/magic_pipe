RSpec.describe MagicPipe::Transports::Log do
  let(:config) do
    MagicPipe::Config.new do |c|
      c.transport = :log
    end
  end

  let(:metrics) { MagicPipe::Metrics.new(config.metrics_client) }

  subject do
    described_class.new(config, metrics)
  end

  describe "submit" do
    let(:payload) { "an encoded payload" }
    let(:metadata) do
      {
        topic: "topic",
        producer: "producer_name",
        time: Time.now.utc.to_i,
        mime: "none"
      }
    end

    def perform
      subject.submit(payload, metadata)
    end

    it "just logs the payload" do
      expect(config.logger).to receive(:info).with(match /an encoded payload/)
      perform
    end
  end
end
