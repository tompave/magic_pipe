module MagicPipe
  class Metrics
    def initialize(config)
      @client = config.metrics_client
      @default_tags = build_default_tags(config)
    end

    attr_reader :client

    def increment(metric, tags: [])
      @client.increment(metric, tags: all_tags(tags))
    end


    private


    def all_tags(list)
      @default_tags + list
    end

    def build_default_tags(config)
      list = [
        "producer:#{config.producer_name.to_s.gsub(" ", "_")}",
        "pipe_instance:#{config.client_name.to_s}",
        "loader:#{config.loader.to_s}",
        "codec:#{config.codec.to_s}",
        "transport:#{transport_tag(config)}",
        "sender:#{config.sender.to_s}",
      ]
    end

    def transport_tag(config)
      t = config.transport
      t.is_a?(Array) ? "multi" : t.to_s
    end

    def method_missing(name, *args, &block)
      client.public_send(name, *args, &block)
    end

    def respond_to_missing?(name, include_all)
      client.respond_to?(name, include_all)
    end
  end
end
