module MagicPipe
  class Client
    def initialize(config)
      @config = config

      @metrics = Metrics.new(config.metrics_client)

      @transport = build_transport

      @codec = Codecs.lookup(config.codec)
      @sender = Senders.lookup(config.sender)
    end

    attr_reader :config, :codec, :transport, :sender, :metrics

    def send_data(object:, topic:, wrapper: nil, time: Time.now.utc)
      sender.new(
        object,
        topic,
        wrapper,
        time,
        codec,
        transport
      ).call
    end


    private

    def build_transport
      klass = Transports.lookup(@config.transport)
      klass.new(@config, @metrics)
    end
  end
end
