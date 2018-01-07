RSpec.describe MagicPipe::Config do
  subject { described_class.new }

  describe "the default configuration values" do
    specify "logger" do
      expect(subject.logger).to be_a Logger
    end

    specify "metrics_client" do
      expect(subject.metrics_client).to be_present
    end
  end
end
