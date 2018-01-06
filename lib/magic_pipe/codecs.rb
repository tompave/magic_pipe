module MagicPipe
  module Codecs
    def self.lookup(type)
      case type
      when :json then Json
      when :thrift then Thrift
      else
        raise "Unknown MagicPipe::Codecs type."
      end
    end
  end
end

files = File.expand_path("../codecs/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
