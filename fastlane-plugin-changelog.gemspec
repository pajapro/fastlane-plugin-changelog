# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/changelog/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-changelog'
  spec.version       = Fastlane::Changelog::VERSION
  spec.author        = %q{Pavel Prochazka}
  spec.email         = %q{pprochazka72@gmail.com}

  spec.summary       = %q{Automate changes to your project CHANGELOG.md}
  spec.homepage      = "https://github.com/pajapro/fastlane-plugin-changelog"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.96.0'
end
