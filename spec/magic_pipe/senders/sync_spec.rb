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

  subject do
    described_class.new(
      object,
      topic,
      wrapper,
      time,
      codec_k,
      transport_i,
      config
    )
  end

  it "has a standard signature to be initialized with three arguments" do
    expect {
      subject
    }.to_not raise_error
  end

  describe "call" do
    subject { super().call }

    it "encodes the data with the codec and sends it with the transport" do
      payload = double("encoded payload")
      codec = double("codec instance", encode: payload)
      expect(codec_k).to receive(:new).with(
        MagicPipe::Envelope.new(
          body: wrapper.new(object),
          topic: topic,
          producer: "steak and ale pie",
          time: time,
          mime: mime
        )
      ).and_return(codec)
      expect(transport_i).to receive(:submit).with(payload)

      subject
    end
  end
end
