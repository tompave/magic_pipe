RSpec.describe MagicPipe::Config do
  subject { described_class.new }

  describe "the default configuration values" do
    specify "client_name" do
      expect(subject.client_name).to be_a String
    end

    specify "producer_name" do
      expect(subject.producer_name).to be_a String
    end

    specify "logger" do
      expect(subject.logger).to be_a Logger
    end

    specify "metrics_client" do
      expect(subject.metrics_client).to_not be_nil
    end

    describe "https_transport_options" do
      specify "when not set, it stays nil" do
        expect(subject.https_transport_options).to be_nil
      end

      describe "when set" do
        subject do
          described_class.new { |c| c.https_transport_options = conf }
        end

        context "with missing values" do
          let(:conf) { {} }

          it "sets all the defaults" do
            actual = subject.https_transport_options

            expect(actual[:url]).to_not be_nil
            expect(actual[:basic_auth_user]).to_not be_nil
            expect(actual[:basic_auth_password]).to_not be_nil
            expect(actual[:timeout]).to_not be_nil
            expect(actual[:open_timeout]).to_not be_nil

            expect(actual[:dynamic_path_builder]).to be_nil
          end
        end

        context "with configured values" do
          let(:fn) { -> (x) { x } }
          let(:conf) do
            {
              url: "http://foo.bar",
              dynamic_path_builder: fn
            }
          end

          it "sets the defaults, but preserved the configured value" do
            actual = subject.https_transport_options

            expect(actual[:url]).to eq "http://foo.bar"
            expect(actual[:dynamic_path_builder]).to eq fn

            expect(actual[:basic_auth_user]).to_not be_nil
            expect(actual[:basic_auth_password]).to_not be_nil
            expect(actual[:timeout]).to_not be_nil
            expect(actual[:open_timeout]).to_not be_nil
          end
        end
      end
    end


    describe "sqs_transport_options" do
      specify "when not set, it gets pre-populated" do
        expect(subject.sqs_transport_options).to be_a Hash
        expect(subject.sqs_transport_options).to_not be_empty
      end

      context "with missing values" do
        it "sets all the defaults" do
          actual = subject.sqs_transport_options
          expect(actual[:queue]).to eq "magic_pipe"
        end
      end

      context "with configured values" do
        subject do
          described_class.new { |c| c.sqs_transport_options = conf }
        end
        let(:conf) { { queue: "foo_bar" } }

        it "sets the defaults, but preserved the configured value" do
          actual = subject.sqs_transport_options
          expect(actual[:queue]).to eq "foo_bar"
        end
      end
    end


    describe "async_transport_options" do
      specify "when not set, it gets pre-populated" do
        expect(subject.async_transport_options).to be_a Hash
        expect(subject.async_transport_options).to_not be_empty
      end

      context "with missing values" do
        it "sets all the defaults" do
          actual = subject.async_transport_options
          expect(actual[:queue]).to eq "magic_pipe"
        end
      end

      context "with configured values" do
        subject do
          described_class.new { |c| c.async_transport_options = conf }
        end
        let(:conf) { { queue: "foo_bar" } }

        it "sets the defaults, but preserved the configured value" do
          actual = subject.async_transport_options
          expect(actual[:queue]).to eq "foo_bar"
        end
      end
    end
  end
end
