require "magic_pipe/version"
require "magic_pipe/config"
require "magic_pipe/metrics"

require "magic_pipe/codecs"
require "magic_pipe/senders"
require "magic_pipe/transports"

module MagicPipe
  # Your code goes here...

  class << self
    def send_data(data)
      config.sender.new(
        data,
        config.codec,
        config.transport
      ).call
    end
  end
end
