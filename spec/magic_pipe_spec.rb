RSpec.describe MagicPipe do
  it "has a version number" do
    expect(MagicPipe::VERSION).not_to be nil
  end

  describe "::config" do
    it "returns the configuration object" do
      expect(MagicPipe.config).to be_an_instance_of MagicPipe::Config
    end
  end
end
