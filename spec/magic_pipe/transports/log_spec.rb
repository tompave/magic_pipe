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
    def perform
      subject.submit(payload)
    end

    it "just logs the payload" do
      expect(config.logger).to receive(:info).with(match /an encoded payload/)
      perform
    end
  end
end
