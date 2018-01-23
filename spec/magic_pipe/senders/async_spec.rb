RSpec.describe MagicPipe::Senders::Async do
  let(:time) { Time.now.utc }
  before do
    MagicPipe.clear_clients
    Timecop.freeze(time)
  end

  after do
    MagicPipe.clear_clients
    Timecop.return
  end

  let(:topic) { "movies_with_ducks" }

  let(:client_name) { :magic_pipe_test_client_4325 }
  let(:producer_name) { "Mr Ducky Duck Face" }

  let(:client) do
    MagicPipe.build do |mp|
      mp.client_name = client_name
      mp.producer_name = producer_name

      mp.codec = :yaml
      mp.loader = :simple_active_record
      mp.transport = :log
      mp.sender = :async
    end
  end

  let(:object) { MagicPipe::TestRecord.find(11) }
  let(:wrapped_object) { MagicPipe::TestRecordSerializer.new(object) }

  let(:decomposed_object) do
    {
      "klass" => "MagicPipe::TestRecord",
      "id" => 11,
      "wrapper" => "MagicPipe::TestRecordSerializer"
    }
  end 

  subject do
    described_class.new(
      object,
      topic,
      MagicPipe::TestRecordSerializer,
      time,
      client.codec,
      client.transport,
      client.config
    )
  end

  it "has a standard signature to be initialized with three arguments" do
    expect {
      subject
    }.to_not raise_error
  end

  describe "#call" do
    def perform
      subject.call
    end

    it "enqueues a Sidekiq job" do
      # symbolize the keys
      dec_obj = decomposed_object.map { |k, v| [k.to_sym, v] }.to_h

      options = {
        "class" => MagicPipe::Senders::Async::Worker,
        "queue" => "magic_pipe",
        "retry" => true,
        "args" => [
          dec_obj,
          topic,
          time.to_i,
          client_name
        ]
      }
      expect(Sidekiq::Client).to receive(:push).with(options)
      perform
    end
  end


  describe MagicPipe::Senders::Async::Worker do
    let(:expected_payload) do
      client.codec.new(
        MagicPipe::Envelope.new(
          body: wrapped_object,
          topic: topic,
          producer: producer_name,
          time: time.to_i,
          mime: "application/x-yaml"
        )
      ).encode
    end

    describe "#perform" do
      def perform
        described_class.new.perform(
          decomposed_object,
          topic,
          time,
          client_name
        )
      end

      it "submits the correct payload to the transport" do
        expect(client.transport).to receive(:submit).with(
          expected_payload,
          {
            topic: topic,
            producer: producer_name,
            time: time.to_i,
            mime: "application/x-yaml"
          }
        )

        perform
      end
    end
  end
end
