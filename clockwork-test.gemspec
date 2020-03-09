# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clockwork/test/version'

Gem::Specification.new do |spec|
  spec.name          = "clockwork-test"
  spec.version       = Clockwork::Test::VERSION
  spec.authors       = ["Kevin Murphy"]
  spec.email         = ["murphy.kevin.mail@gmail.com"]
  spec.summary       = "Test clockwork scheduled jobs"
  spec.description   = "Run clockwork jobs in a test environment and assert jobs are run as expected"
  spec.homepage      = "https://github.com/kevin-j-m/clockwork-test"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"

  spec.add_runtime_dependency "clockwork"
  spec.add_runtime_dependency "timecop"
end
