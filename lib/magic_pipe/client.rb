module MagicPipe
  class Client
    def initialize(config)
      @config = config

      @metrics = Metrics.new(config.metrics_client)

      @codec = Codecs.lookup(config.codec)
      @transport = Transports.lookup(config.transport)
      @sender = Senders.lookup(config.sender)
    end

    attr_reader :config, :codec, :transport, :sender, :metrics

    def send_data(data)
      sender.new(
        data,
        codec,
        transport
      ).call
    end
  end
end
