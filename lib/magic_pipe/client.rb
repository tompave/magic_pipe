module MagicPipe
  class Client
    def initialize(config)
      @config = config
      @name = config.client_name

      @metrics = Metrics.new(@config)

      @transport = build_transport

      @codec = Codecs.lookup(config.codec)
      @sender = Senders.lookup(config.sender)

      @loader = Loaders.lookup(config.loader)
    end

    attr_reader :name, :config, :codec, :transport, :sender, :loader, :metrics

    def send_data(object:, topic:, wrapper: nil, time: Time.now.utc)
      sender.new(
        object,
        topic,
        wrapper,
        time,
        codec,
        transport,
        @config
      ).call
    end


    private

    def build_transport
      klass = Transports.lookup(@config.transport)
      klass.new(@config, @metrics)
    end
  end
end
