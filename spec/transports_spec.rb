RSpec.describe MagicPipe::Transports do
  describe "::lookup" do
    example "with :https it returns the Https transport class" do
      expect(subject.lookup(:https)).to eq MagicPipe::Transports::Https
    end

    example "with :sqs it returns the Sqs transport class" do
      expect(subject.lookup(:sqs)).to eq MagicPipe::Transports::Sqs
    end
  end
end
