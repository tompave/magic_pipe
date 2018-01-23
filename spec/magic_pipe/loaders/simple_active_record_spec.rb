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
    shared_examples_for "common failures" do
      context "with an invalid record class name" do
        let(:record_k_n) { "MagicPipe::NotExistingClass" }

        it "raises an error" do
          expect {
            perform
          }.to raise_error(
            MagicPipe::LoaderError,
            "Can't resolve class name 'MagicPipe::NotExistingClass' (ActiveRecord model)"
          )
        end
      end

      specify "non existing record raise the usual RecordNotFound errors" do
        allow(MagicPipe::TestRecord).to receive(:find).and_raise(
          StandardError,
          "I'm pretending to be an ActiveRecord::RecordNotFound error."
        )

        expect {
          perform
        }.to raise_error(
          StandardError,
          "I'm pretending to be an ActiveRecord::RecordNotFound error."
        )
      end
    end

    context "without wrapper" do
      def perform
        described_class.load(
          { klass: record_k_n, id: 11 }
        )
      end

      it "fetches the record" do
        expect(perform).to eq MagicPipe::TestRecord.find(11)
      end

      describe "failures" do
        include_examples "common failures"
      end
    end

    context "with wrapper" do
      def perform
        described_class.load(
          { klass: record_k_n, id: 11, wrapper: serializer_k_n }
        )
      end

      it "fetches and wraps the record" do
        expect(perform).to eq(
          MagicPipe::TestRecordSerializer.new(
            MagicPipe::TestRecord.find(11)
          )
        )
      end

      describe "failures" do
        include_examples "common failures"

        context "with an invalid serializer class name" do
          let(:serializer_k_n) { "MagicPipe::NotExistingClass" }

          it "raises an error" do
            expect {
              perform
            }.to raise_error(
              MagicPipe::LoaderError,
              "Can't resolve class name 'MagicPipe::NotExistingClass' (object serializer)"
            )
          end
        end
      end
    end
  end
end
