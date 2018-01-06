RSpec.describe MagicPipe::Senders do
  describe "::lookup" do
    example "with :sync it returns the Sync sender class" do
      expect(subject.lookup(:sync)).to eq MagicPipe::Senders::Sync
    end

    example "with :async it returns the Sync sender class" do
      expect(subject.lookup(:async)).to eq MagicPipe::Senders::Async
    end
  end
end
