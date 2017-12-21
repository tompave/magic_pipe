module MagicPipe
  module Codecs
  end
end

files = File.expand_path("../codecs/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
