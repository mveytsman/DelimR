# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delimr/version'

Gem::Specification.new do |spec|
  spec.name          = "delimr"
  spec.version       = Delimr::VERSION
  spec.authors       = ["Max Veytsman"]
  spec.email         = ["maxim@ontoillogical.com"]
  spec.summary       = %q{Delimited continuations in Ruby.}
  spec.description   = %q{This gem provides delimited continuations (shift/reset) in ruby.}
  spec.homepage      = "https://github.com/mveytsman/delimr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
