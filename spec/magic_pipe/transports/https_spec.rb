require "base64"

RSpec.describe MagicPipe::Transports::Https do
  let(:url) { "https://localhost:8080/test" }
  let(:auth_token) { "test-token" }
  let(:auth_header) { "Basic " + Base64.strict_encode64("#{auth_token}:x") }

  let(:config) do
    MagicPipe::Config.new do |c|
      c.codec = :yaml
      c.transport = :https

      c.https_transport_options = {
        url: url,
        auth_token: auth_token,
      }
    end
  end

  let(:metrics) { MagicPipe::Metrics.new(config.metrics_client) }

  subject do
    described_class.new(config, metrics)
  end

  describe "the faraday connection" do
    let(:conn) { subject.conn}

    it "is configured with the right URL" do
      expect(conn.url_prefix).to eq URI(url)
    end

    it "is configured with the right headers" do
      expect(conn.headers["Content-Type"]).to eq "application/x-yaml"
      expect(conn.headers["User-Agent"]).to match(
        %r{\AMagicPipe v[\d\.]+ \(Faraday v[\d\.]+, Typhoeus v[\d\.]+\)\z}
      )
    end
  end

  describe "submit" do
    let(:payload) { "an encoded payload" }
    let(:metadata) do
      {
        topic: "marsupials",
        producer: "Mr. Koala",
        time: 123123123,
        mime: "none"
      }
    end

    def perform
      subject.submit(payload, metadata)
    end

    it "submits a request with the correct data" do
      stub_request(:post, url).with(
        body: payload,
        headers: {
          "Content-Type" => "application/x-yaml",
          "Authorization" => auth_header,
          "X-MagicPipe-Sent-At" => 123123123,
          "X-MagicPipe-Topic" => "marsupials",
          "X-MagicPipe-Producer" => "Mr. Koala"
        }
      )

      perform
    end
  end
end
