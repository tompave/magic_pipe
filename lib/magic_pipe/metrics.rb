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
      if t.is_a?(Array)
        "multi_" + t.map { |s| sanitize_tag_string(s) }.join("-")
      else
        t.to_s
      end
    end

    def sanitize_tag_string(value)
      value.to_s.tr(":. /", "")
    end

    def method_missing(name, *args, &block)
      client.public_send(name, *args, &block)
    end

    def respond_to_missing?(name, include_all)
      client.respond_to?(name, include_all)
    end
  end
end
