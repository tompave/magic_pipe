RSpec.describe MagicPipe::Transports do
  describe "::lookup" do
    example "with :https it returns the Https transport class" do
      expect(subject.lookup(:https)).to eq MagicPipe::Transports::Https
    end

    example "with :sqs it returns the Sqs transport class" do
      expect(subject.lookup(:sqs)).to eq MagicPipe::Transports::Sqs
    end

    example "with an Array it returns the Multi transport class" do
      expect(subject.lookup([:foo, :bar])).to eq MagicPipe::Transports::Multi
    end

    example "with a class it returns the class" do
      expect(subject.lookup(String)).to eq String
    end

    example "with an unknown value it raises an error" do
      expect { subject.lookup(:invalid) }.to raise_error(MagicPipe::ConfigurationError)
    end
  end
end
