module MagicPipe
  module Transports
  end
end

files = File.expand_path("../transports/**/*.rb", __FILE__)
Dir[files].each { |f| require f }
