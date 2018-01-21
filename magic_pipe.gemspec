
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "magic_pipe/version"

Gem::Specification.new do |spec|
  spec.name          = "magic_pipe"
  spec.version       = MagicPipe::VERSION
  spec.authors       = ["Tommaso Pavese"]
  spec.email         = ["tommaso@pavese.me"]

  spec.summary       = %q{A Magic Pipe to send data to a backend.}
  spec.description   = %q{A Magic Pipe to send JSON data to a configurable backend in response to ActiveRecord lifecycle events.}
  spec.homepage      = "https://github.com/deliveroo/magic_pipe-rb"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "pry"

  spec.add_development_dependency 'sidekiq', '~> 5.0'
  spec.add_development_dependency 'oj'
  spec.add_development_dependency 'msgpack'
end
