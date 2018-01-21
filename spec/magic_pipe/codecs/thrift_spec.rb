RSpec.describe MagicPipe::Codecs::Thrift do
  let(:object) { { foo: "bar", baz: [1, 2, 3] } }
  subject { described_class.new(object) }

  describe "type" do
    it "returns application/vnd.apache.thrift.binary" do
      expect(subject.type).to eq "application/vnd.apache.thrift.binary"
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
