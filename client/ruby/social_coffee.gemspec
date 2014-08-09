# config: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_coffee/version'

Gem::Specification.new do |spec|
    spec.name           = "social_coffee"
    spec.version        = SocialCoffee::VERSION
    spec.authors        = ["iaintshine"]
    spec.email          = ["bodziomista@gmail.com"]
    spec.summary        = %q{A Ruby client library for interacting with Social Coffee thrift service}
    spec.description    = %q{A Ruby client library for interacting with Social Coffee thrift service}
    spec.homepage       = "https://github.com/iaintshine/social_coffee"
    spec.license        = "MIT"

    spec.files         = `git ls-files`.split($/)
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_dependency "thrift", "~> 1.0.0.0"

    spec.add_development_dependency "bundler", "~> 1.5"
    spec.add_development_dependency "rake"
    spec.add_development_dependency "rspec", "~> 2.14.1"
    spec.add_development_dependency "fuubar"
end