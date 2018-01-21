RSpec.describe MagicPipe::Codecs::MessagePack do
  let(:time) { Time.now }
  let(:date) { Date.today }

  let(:object) do
    {
      "foo" => "bar",
      "baz" => [1, 2, 3],
      "qwe" => { "rty" => "foo" },
      "t" => time,
      "d" => date,
    }
  end
  subject { described_class.new(object) }

  describe "type" do
    it "returns application/x-msgpack" do
      expect(subject.type).to eq "application/x-msgpack"
    end
  end

  describe "encode" do
    subject { super().encode }

    it "returns a string" do
      expect(subject).to be_a String
    end

    it "returns a valid MessagePack payload" do
      out = nil

      expect {
        out = MessagePack.unpack(subject)
      }.to_not raise_error

      # Compare the times as integers, to avoid issues
      # with the loss of microsecond precision.
      expect(out["t"].to_i).to eq time.to_i

      # Ignore the time
      out.delete("t")
      object.delete("t")

      expect(out).to eq object
    end
  end
end
