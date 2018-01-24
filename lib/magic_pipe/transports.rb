module MagicPipe
  module Transports
    def self.lookup(type)
      case type
      when :https then Https
      when :sqs then Sqs
      when :log then Log
      when :debug then Debug
      when Array then Multi
      when Class then type
      else
        raise ConfigurationError, "Unknown MagicPipe::Transports type: '#{type}'."
      end
    end
  end
end

files = File.expand_path("../transports/**/*.rb", __FILE__)
Dir[files].each do |f|
  begin
    require f
  rescue LoadError
    # Some components have extra dependencies
  end
end

