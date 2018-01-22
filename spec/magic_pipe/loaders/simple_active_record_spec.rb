RSpec.describe MagicPipe::Loaders::SimpleActiveRecord do
  let(:record) { MagicPipe::TestRecord.new(42, "hello") }
  let(:record_k) { MagicPipe::TestRecord }
  let(:serializer_k) { MagicPipe::TestRecordSerializer }


  describe "#decompose" do
    context "without wrapper" do
      subject { described_class.new(record) }

      it "returns data to fetch the record later" do
        expect(subject.decompose).to eq({
          klass: record_k,
          id: 42,
          wrapper: nil
        })
      end
    end

    context "with wrapper" do
      subject { described_class.new(record, serializer_k) }

      it "returns data to fetch the record later" do
        expect(subject.decompose).to eq({
          klass: record_k,
          id: 42,
          wrapper: serializer_k
        })
      end
    end
  end


  describe "::load" do
    context "without wrapper" do
      def perform
        described_class.load(
          record_k,
          11
        )
      end

      it "fetches the record" do
        expect(perform).to eq record_k.find(11)
      end
    end

    context "with wrapper" do
      def perform
        described_class.load(
          record_k,
          11,
          serializer_k
        )
      end

      it "fetches and wraps the record" do
        expect(perform).to eq serializer_k.new(record_k.find(11))
      end
    end
  end
end
