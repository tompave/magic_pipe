module MagicPipe
  module Senders
    def self.lookup(type)
      case type
      when :sync then Sync
      when :async then Async
      when Class then type
      else
        raise ConfigurationError, "Unknown MagicPipe::Senders type: '#{type}'."
      end
    end
  end
end

files = File.expand_path("../senders/**/*.rb", __FILE__)
Dir[files].each do |f|
  begin
    require f
  rescue LoadError
    # Some components have extra dependencies
  end
end

