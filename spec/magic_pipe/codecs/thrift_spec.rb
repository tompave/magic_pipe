RSpec.describe MagicPipe::Codecs::Thrift do
  let(:object) { { foo: "bar", baz: [1, 2, 3] } }
  subject { described_class.new(object) }

  describe "encoding" do
    it "returns thrift" do
      expect(subject.encoding).to eq "thrift"
    end
  end

  describe "encode" do
    subject { super().encode }

    it "returns a string" do
      expect(subject).to be_a String
    end

    xit "returns a Thrift blob" do
      # pending
    end
  end
end
