module MagicPipe
  module Senders
    def self.lookup(type)
      case type
      when :sync then Sync
      when :async then Async
      else
        raise "Unknown MagicPipe::Senders type."
      end
    end
  end
end

files = File.expand_path("../senders/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
