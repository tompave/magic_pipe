RSpec.describe MagicPipe do
  it "has a version number" do
    expect(MagicPipe::VERSION).not_to be nil
  end

  describe "::build" do
    def good_build
      MagicPipe.build do |c|
        c.codec = :json
        c.transport = :https
        c.https_transport_options = {} # let the defaults apply
        c.sender = :sync
      end
    end

    it "requires a block" do
      expect {
        MagicPipe.build
      }.to raise_error(MagicPipe::ConfigurationError, "No configuration block provided.")

      expect {
        good_build
      }.to_not raise_error
    end

    describe "with a good configuration block" do
      subject { good_build }

      it "returns a client object" do
        expect(subject).to be_an_instance_of MagicPipe::Client
      end

      specify "the client is set up with the correct settings" do
        expect(subject.transport).to be_an_instance_of(MagicPipe::Transports::Https)

        expect(subject.codec).to eq MagicPipe::Codecs::Json
        expect(subject.sender).to eq MagicPipe::Senders::Sync
      end
    end


    describe "with unknown codec, transport or sender values" do
      it "raises an error" do
        expect {
          MagicPipe.build do |c|
            c.codec = :invalid
            c.transport = :https
            c.https_transport_options = {} # let the defaults apply
            c.sender = :sync
          end
        }.to raise_error(MagicPipe::ConfigurationError)

        expect {
          MagicPipe.build do |c|
            c.codec = :json
            c.transport = :invalid
            c.sender = :sync
          end
        }.to raise_error(MagicPipe::ConfigurationError)

        expect {
          MagicPipe.build do |c|
            c.codec = :json
            c.transport = :https
            c.https_transport_options = {} # let the defaults apply
            c.sender = :invalid
          end
        }.to raise_error(MagicPipe::ConfigurationError)
      end
    end
  end
end
