# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'z85rb/version'

Gem::Specification.new do |spec|
  spec.name          = "z85rb"
  spec.version       = Z85rb::VERSION
  spec.authors       = ["Jakukyo Friel"]
  spec.email         = ["weakish@gmail.com"]
  spec.description   = %q{Pure Ruby implementiation of Z85 encoding.}
  spec.summary       = %q{Pure Ruby implementiation of Z85 encoding.}
  spec.homepage      = "https://github.com/weakish/z85rb"
  spec.license       = "0BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard-doctest'
end
