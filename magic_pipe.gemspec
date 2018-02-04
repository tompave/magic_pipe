
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "magic_pipe/version"

Gem::Specification.new do |spec|
  spec.name          = "magic_pipe"
  spec.version       = MagicPipe::VERSION
  spec.authors       = ["Tommaso Pavese"]
  spec.email         = ["tommaso@pavese.me"]

  spec.summary       = %q{A Magic Pipe to send data in arbitrary formats to configurable backends, with topics.}

  spec.description   = %q{A Magic Pipe to send data in arbitrary formats to configurable backends, with topics.} +
                       %q{ It features a modular design that allows to configure and extend how the payloads are} +
                       %q{ fetched, serialized, encoded, submitted, and most importantly where: SQS, HTTPS} +
                       %q{ endpoints, etc.}

  spec.homepage      = "https://github.com/tompave/magic_pipe"

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

  spec.add_development_dependency 'typhoeus'
  spec.add_development_dependency 'faraday'

  spec.add_development_dependency 'aws-sdk-sqs', '~> 1.3'

  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'timecop'
end
