module MagicPipe
  module Codecs
    def self.lookup(type)
      case type
      when :json then Json
      when :thrift then Thrift
      when Class then type
      else
        raise ConfigurationError, "Unknown MagicPipe::Codecs type: '#{type}'."
      end
    end
  end
end

files = File.expand_path("../codecs/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
