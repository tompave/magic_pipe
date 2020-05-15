RSpec.describe MagicPipe::Client do
  let(:logger) { double(:logger, start: nil, finish: nil) }
  let(:config) do
    MagicPipe::Config.new do |c|
      c.client_name = :foo_bar
      c.codec = :json
      c.transport = :https
      c.https_transport_options = {} # let the defaults apply
      c.sender = :sync
      c.before_send = -> { logger.start }
      c.after_send = -> { logger.finish }
    end
  end

  subject { described_class.new(config) }

  describe "creation and configuration" do
    it "can access the configuration" do
      expect(subject.config).to eq config

      expect(subject.transport).to be_an_instance_of(MagicPipe::Transports::Https)

      expect(subject.codec).to eq MagicPipe::Codecs::Json
      expect(subject.sender).to eq MagicPipe::Senders::Sync
    end
  end


  describe "name" do
    it "returns the configured client name" do
      expect(subject.name).to eq :foo_bar
    end
  end

  describe "metrics" do
    it "returns a Metrics object" do
      expect(subject.metrics).to be_a MagicPipe::Metrics
    end
  end

  describe "send_data" do
    let(:time) { Time.now.utc }
    let(:object) { MagicPipe::TestRecord.new(123) }
    let(:sender) { double("sender") }

    def perform
      subject.send_data(
        object: object,
        topic: "mammals",
        wrapper: MagicPipe::TestRecordSerializer,
        time: time
      )
    end

    it "instantiates and calls the sender" do
      expect(MagicPipe::Senders::Sync).to receive(:new).with(
        object,
        "mammals",
        MagicPipe::TestRecordSerializer,
        time,
        MagicPipe::Codecs::Json,
        subject.transport, # an instiated transport object
        config,
        subject.metrics
      ).and_return(sender)

      expect(logger).to receive(:start).ordered
      expect(sender).to receive(:call).ordered
      expect(logger).to receive(:finish).ordered

      perform
    end

    it "returns true" do
      stub_request(:post, "https://localhost:8080/foo").
        to_return(status: 200, body: "", headers: {})
      expect(perform).to eq true
    end
  end
end
