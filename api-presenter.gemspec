# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api/presenter/version'

Gem::Specification.new do |spec|
  spec.name          = "api-presenter"
  spec.version       = Api::Presenter::VERSION
  spec.authors       = ["Álvaro Lara"]
  spec.email         = ["alvarola@gmail.com"]
  spec.description   = 'A JSON resource presenter for a specific api media type'
  spec.summary       = 'A JSON resource presenter for a specific api media type'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency "multi_json", "~> 1.7.4"
  spec.add_dependency "json", "~> 1.7.7"
end
