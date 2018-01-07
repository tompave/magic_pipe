RSpec.describe MagicPipe::Senders do
  describe "::lookup" do
    example "with :sync it returns the Sync sender class" do
      expect(subject.lookup(:sync)).to eq MagicPipe::Senders::Sync
    end

    example "with :async it returns the Sync sender class" do
      expect(subject.lookup(:async)).to eq MagicPipe::Senders::Async
    end

    example "with a class it returns the class" do
      expect(subject.lookup(String)).to eq String
    end

    example "with an unknown value it raises an error" do
      expect { subject.lookup(:invalid) }.to raise_error(MagicPipe::ConfigurationError)
    end
  end
end
