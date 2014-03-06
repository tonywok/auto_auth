# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'generators/auto_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "auto_auth"
  spec.version       = AutoAuth::VERSION
  spec.authors       = ["Tony Schneider"]
  spec.email         = ["tonywok@gmail.com"]
  spec.summary       = %q{Simple authentication ready to be customized.}
  spec.homepage      = "https://github.com/tonywok/auto_auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
