# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_exposure/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_exposure'
  spec.version       = SimpleExposure::VERSION
  spec.authors       = ['Michal Krejčí']
  spec.email         = ['work@mikekreeki.com']
  spec.description   = 'Cleanup your Rails controllers'
  spec.summary       = 'Cleanup your Rails controllers'
  spec.homepage      = 'https://github.com/mikekreeki/simple_exposure'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
