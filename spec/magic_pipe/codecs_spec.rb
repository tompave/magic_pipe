RSpec.describe MagicPipe::Codecs do
  describe "::lookup" do
    example "with :json it returns the Json codec class" do
      expect(subject.lookup(:json)).to eq MagicPipe::Codecs::Json
    end

    example "with :thrift it returns the Thrift codec class" do
      expect(subject.lookup(:thrift)).to eq MagicPipe::Codecs::Thrift
    end
  end
end
