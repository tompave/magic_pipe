RSpec.describe MagicPipe::Loaders do
  describe "::lookup" do
    example "with :simple_active_record it returns the SimpleActiveRecord sender class" do
      expect(subject.lookup(:simple_active_record)).to eq MagicPipe::Loaders::SimpleActiveRecord
    end

    example "with a class it returns the class" do
      expect(subject.lookup(String)).to eq String
    end

    example "with an unknown value it raises an error" do
      expect { subject.lookup(:invalid) }.to raise_error(MagicPipe::ConfigurationError)
    end
  end
end
