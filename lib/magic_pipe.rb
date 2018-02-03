require "magic_pipe/version"
require "magic_pipe/errors"

require "magic_pipe/config"
require "magic_pipe/metrics"

require "magic_pipe/envelope"

require "magic_pipe/loaders"
require "magic_pipe/codecs"
require "magic_pipe/senders"
require "magic_pipe/transports"

require "magic_pipe/client"

require "pry"

module MagicPipe
  class << self
    def lookup_client(name)
      @store[name.to_sym]
    end

    # All this should be loaded before Sidekiq
    # or Puma start forking threads.
    #
    def store_client(client)
      @store ||= {}
      @store[client.name.to_sym] = client
    end

    def clear_clients
      @store = {}
    end

    def build(&block)
      unless block_given?
        raise ConfigurationError, "No configuration block provided."
      end

      config = Config.new(&block)
      client = Client.new(config)
      store_client(client)
      client
    end
  end
end
