# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seko/version'

Gem::Specification.new do |spec|
  spec.name          = "seko"
  spec.version       = Seko::VERSION
  spec.authors       = ["Justin Grubbs"]
  spec.email         = ["justin@jgrubbs.net"]
  spec.summary       = %q{A ruby wrapper for interfacing with Seko Logistics' SupplySteam iHub API}
  spec.description   = %q{A ruby wrapper for interfacing with Seko Logistics' SupplySteam iHub API}
  spec.homepage      = "https://github.com/jGRUBBS/seko-ruby-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "hashie"
  spec.add_development_dependency "codeclimate-test-reporter"
end
