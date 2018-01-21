RSpec.describe MagicPipe::Codecs do
  describe "::lookup" do
    example "with :json it returns the Json codec class" do
      expect(subject.lookup(:json)).to eq MagicPipe::Codecs::Json
    end

    example "with :thrift it returns the Thrift codec class" do
      expect(subject.lookup(:thrift)).to eq MagicPipe::Codecs::Thrift
    end

    example "with :msgpack or :message_pack it returns the MessagePack codec class" do
      expect(subject.lookup(:msgpack)).to eq MagicPipe::Codecs::MessagePack
      expect(subject.lookup(:message_pack)).to eq MagicPipe::Codecs::MessagePack
    end

    example "with :yaml it returns the Yaml codec class" do
      expect(subject.lookup(:yaml)).to eq MagicPipe::Codecs::Yaml
    end

    example "with a class it returns the class" do
      expect(subject.lookup(String)).to eq String
    end

    example "with an unknown value it raises an error" do
      expect { subject.lookup(:invalid) }.to raise_error(MagicPipe::ConfigurationError)
    end
  end
end
