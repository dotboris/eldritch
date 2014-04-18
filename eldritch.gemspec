# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eldritch/version'

Gem::Specification.new do |spec|
  spec.name          = 'eldritch'
  spec.version       = Eldritch::VERSION
  spec.authors       = ['Boris Bera', 'François Genois']
  spec.email         = %w(bboris@rsoft.ca frankgenerated@gmail.com)
  spec.summary       = %q{Adds tools to make parallelism easier.}
  spec.description   = %q{Adds support for async methods and async blocks. Adds a together block that allows async methods/blocks to be controlled as a group.}
  spec.homepage      = 'https://github.com/beraboris/eldritch'
  spec.license       = 'MIT'

  # need refinements
  spec.required_ruby_version = '>= 2.1'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'yard', '~> 0.8.7.4'
end
