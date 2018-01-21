module MagicPipe
  module Codecs
    def self.lookup(type)
      case type
      when :json then Json
      when :thrift then Thrift
      when :msgpack, :message_pack then MessagePack
      when :yaml then Yaml
      when Class then type
      else
        raise ConfigurationError, "Unknown MagicPipe::Codecs type: '#{type}'."
      end
    end
  end
end

files = File.expand_path("../codecs/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
