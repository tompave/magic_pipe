RSpec.describe MagicPipe::Metrics do
  let(:statsd) do
    double("Statsd client", increment: nil)
  end

  let(:config) do
    MagicPipe::Config.new do |c|
      c.producer_name = "FooBar Test"
      c.client_name = :foo_bar
      c.loader = :custom_loader
      c.codec = :json
      c.transport = :sqs
      c.sender = :sync
      c.metrics_client = statsd
    end
  end

  subject { described_class.new(config) }

  describe "it responds to the statsd methods" do
    example "increment" do
      expect {
        subject.increment "fancy.metric.name", tags: ["foo:bar"]
      }.to_not raise_error
    end
  end


  describe "#increment" do
    it "forwards the message to the statsd client" do
      expect(statsd).to receive(:increment).with(
        "foo.bar",
        { tags: array_including("qwe:rty") }
      )

      subject.increment("foo.bar", tags: ["qwe:rty"])
    end


    it "augments the tags with the default tags" do
      expect(statsd).to receive(:increment).with(
        "foo.bar",
        {
          tags: [
            "producer:FooBar_Test",
            "pipe_instance:foo_bar",
            "loader:custom_loader",
            "codec:json",
            "transport:sqs",
            "sender:sync",
            "qwe:rty", # the explicitly passed one!
          ]
        }
      )

      subject.increment("foo.bar", tags: ["qwe:rty"])
    end
  end
end
