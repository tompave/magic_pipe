module MagicPipe
  class Client
    def initialize(config)
      @config = config

      @metrics = Metrics.new(config.metrics_client)

      @transport =
        Transports.lookup(config.transport)
          .new(@metrics, config.logger)

      @codec = Codecs.lookup(config.codec)
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
