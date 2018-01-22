module MagicPipe
  module Loaders
    def self.lookup(type)
      case type
      when :simple_active_record then SimpleActiveRecord
      when Class then type
      else
        raise ConfigurationError, "Unknown MagicPipe::Loaders type: '#{type}'."
      end
    end
  end
end

files = File.expand_path("../loaders/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
