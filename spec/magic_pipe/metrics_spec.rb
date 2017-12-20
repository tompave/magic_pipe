RSpec.describe MagicPipe::Metrics do
  subject { described_class }

  describe "it responds to the statsd methods" do
    example "increment" do
      expect {
        subject.increment "fancy.metric.name", 2
      }.to_not raise_error
    end
  end
end
