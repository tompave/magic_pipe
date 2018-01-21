RSpec.describe MagicPipe::Codecs::Json do
  let(:object) { { foo: "bar", baz: [1, 2, 3] } }
  subject { described_class.new(object) }

  describe "type" do
    it "returns application/json" do
      expect(subject.type).to eq "application/json"
    end
  end

  describe "encode" do
    subject { super().encode }

    it "returns a string" do
      expect(subject).to be_a String
    end

    it "returns valid JSON" do
      expect {
        JSON.parse(subject)
      }.to_not raise_error
    end
  end
end
