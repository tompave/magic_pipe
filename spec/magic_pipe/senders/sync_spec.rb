RSpec.describe MagicPipe::Senders::Sync do
  let(:data) { double("some ruby object or hash") }
  let(:codec_k) { double("codec class") }
  let(:transport_i) { double("transport instance") }

  subject do
    described_class.new(data, codec_k, transport_i)
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
      expect(codec_k).to receive(:new).with(data).and_return(codec)
      expect(transport_i).to receive(:submit).with(payload)

      subject
    end
  end
end
