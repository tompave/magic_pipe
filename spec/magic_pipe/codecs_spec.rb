RSpec.describe MagicPipe::Codecs do
  describe "::lookup" do
    example "with :json it returns the Json codec class" do
      expect(subject.lookup(:json)).to eq MagicPipe::Codecs::Json
    end

    example "with :thrift it returns the Thrift codec class" do
      expect(subject.lookup(:thrift)).to eq MagicPipe::Codecs::Thrift
    end

    example "with a class it returns the class" do
      expect(subject.lookup(String)).to eq String
    end

    example "with an unknown value it raises an error" do
      expect { subject.lookup(:invalid) }.to raise_error(MagicPipe::ConfigurationError)
    end
  end
end
