RSpec.describe MagicPipe::Metrics do
  let(:client) { double("metrics client", increment: nil) }
  subject { described_class.new(client) }

  describe "it responds to the statsd methods" do
    example "increment" do
      expect {
        subject.increment "fancy.metric.name", 2
      }.to_not raise_error
    end
  end
end
