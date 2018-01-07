module MagicPipe
  class Metrics
    def initialize(client)
      @client = client
    end

    attr_reader :client

    def method_missing(name, *args, &block)
      client.public_send(name, *args, &block)
    end

    def respond_to_missing?(name, include_all)
      client.respond_to?(name, include_all)
    end
  end
end
