require "bundler/setup"
require "magic_pipe"
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    WebMock.enable!
    WebMock.disable_net_connect!
  end
  config.after(:suite) do
    WebMock.allow_net_connect!
    WebMock.disable!
  end
end
