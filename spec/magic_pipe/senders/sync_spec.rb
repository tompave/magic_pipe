RSpec.describe MagicPipe::Senders::Sync do
  let(:object) { MagicPipe::TestRecord.new(123) }
  let(:topic) { "bananas" }
  let(:wrapper) { MagicPipe::TestRecordSerializer }
  let(:time) { Time.now.utc }

  let(:codec_k) { MagicPipe::Codecs::Yaml }
  let(:mime) { codec_k::TYPE }

  let(:transport_i) { double("transport instance") }
  
  let(:config) do
    MagicPipe::Config.new do |c|
      c.producer_name = "steak and ale pie"
    end
  end

  let(:metrics) { double("Metrics", increment: nil) }

  let(:envelope) do
    MagicPipe::Envelope.new(
      body: wrapper.new(object),
      topic: topic,
      producer: "steak and ale pie",
      time: time,
      mime: mime
    )
  end

  let(:metadata) do
    {
      topic: topic,
      producer: "steak and ale pie",
      time: time.to_i,
      mime: mime
    }
  end

  subject do
    described_class.new(
      object,
      topic,
      wrapper,
      time,
      codec_k,
      transport_i,
      config,
      metrics
    )
  end

  it "has a standard signature to be initialized with three arguments" do
    expect {
      subject
    }.to_not raise_error
  end

  describe "call" do
    def perform
      subject.call
    end

    let(:payload) { double("encoded payload") }
    let(:codec) { double("codec instance", encode: payload) }

    it "encodes the data with the codec and sends it with the transport" do
      expect(codec_k).to receive(:new).with(envelope).and_return(codec)
      expect(transport_i).to receive(:submit).with(payload, metadata)
      perform
    end

    describe "tracking and metrics" do
      context "on success" do
        before do
          allow(codec_k).to receive(:new).with(envelope).and_return(codec)
          allow(transport_i).to receive(:submit).with(payload, metadata)
        end

        it "tracks the action with the metrics object" do
          expect(metrics).to receive(:increment).with(
            "magic_pipe.senders.sync.mgs_sent",
            { tags: array_including("topic:#{topic}") }
          )
          perform
        end
      end

      context "on failure" do
        before do
          allow(codec_k).to receive(:new).with(envelope).and_return(codec)
          allow(transport_i).to receive(:submit).with(payload, metadata) do
            raise MagicPipe::Error, "oh no"
          end
        end

        def perform
          super
        rescue MagicPipe::Error
        end

        it "tracks the failure with the metrics object" do
          expect(metrics).to receive(:increment).with(
            "magic_pipe.senders.sync.failure",
            { tags: array_including("topic:#{topic}") }
          )
          perform
        end
      end
    end
  end
end
