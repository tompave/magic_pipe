require "magic_pipe/version"
require "magic_pipe/errors"

require "magic_pipe/config"
require "magic_pipe/metrics"

require "magic_pipe/loaders"
require "magic_pipe/codecs"
require "magic_pipe/senders"
require "magic_pipe/transports"

require "magic_pipe/client"

module MagicPipe
  def self.build(&block)
    unless block_given?
      raise ConfigurationError, "No configuration block provided."
    end

    config = Config.new(&block)
    Client.new(config)
  end
end
