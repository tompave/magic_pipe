module MagicPipe
  module Senders
  end
end

files = File.expand_path("../senders/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
