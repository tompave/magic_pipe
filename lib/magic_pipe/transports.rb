module MagicPipe
  module Transports
    def self.lookup(type)
      case type
      when :https then Https
      when :sqs then Sqs
      else
        raise "Unknown MagicPipe::Transports type."
      end
    end
  end
end

files = File.expand_path("../transports/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
