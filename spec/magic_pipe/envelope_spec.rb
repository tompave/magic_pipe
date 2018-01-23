RSpec.describe MagicPipe::Envelope do
  let(:body) { MagicPipe::TestRecord.new(123) }
  let(:topic) { "bananas" }
  let(:producer) { "acme" }
  let(:time) { Time.now.utc }
  let(:mime) { "text/x-batman" }

  subject do
    described_class.new(
      body: body,
      topic: topic,
      producer: producer,
      time: time,
      mime: mime
    )
  end

  describe "#as_json" do
    def perform
      subject.as_json
    end

    it "return a Hash" do
      expect(perform).to be_a Hash
    end

    specify "with the right value" do
      h = perform
      expect(h[:body]).to eq body.as_json
      expect(h[:topic]).to eq topic
      expect(h[:producer]).to eq producer
      expect(h[:time]).to eq time.to_i
      expect(h[:mime]).to eq mime
    end
  end
end
