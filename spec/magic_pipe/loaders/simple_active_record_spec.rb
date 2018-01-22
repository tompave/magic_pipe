RSpec.describe MagicPipe::Loaders::SimpleActiveRecord do
  let(:record) { MagicPipe::TestRecord.new(42, "hello") }
  let(:record_k_n) { "MagicPipe::TestRecord" }
  let(:serializer_k_n) { "MagicPipe::TestRecordSerializer" }


  describe "#decompose" do
    context "without wrapper" do
      subject { described_class.new(record) }

      it "returns data to fetch the record later" do
        expect(subject.decompose).to eq({
          klass: record_k_n,
          id: 42,
          wrapper: nil
        })
      end
    end

    context "with wrapper" do
      subject { described_class.new(record, MagicPipe::TestRecordSerializer) }

      it "returns data to fetch the record later" do
        expect(subject.decompose).to eq({
          klass: record_k_n,
          id: 42,
          wrapper: serializer_k_n
        })
      end
    end
  end


  describe "::load" do
    context "without wrapper" do
      def perform
        described_class.load(
          record_k_n,
          11
        )
      end

      it "fetches the record" do
        expect(perform).to eq MagicPipe::TestRecord.find(11)
      end
    end

    context "with wrapper" do
      def perform
        described_class.load(
          record_k_n,
          11,
          serializer_k_n
        )
      end

      it "fetches and wraps the record" do
        expect(perform).to eq(
          MagicPipe::TestRecordSerializer.new(
            MagicPipe::TestRecord.find(11)
          )
        )
      end
    end
  end
end
