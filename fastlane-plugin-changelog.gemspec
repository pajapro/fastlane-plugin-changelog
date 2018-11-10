lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/changelog/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-changelog'
  spec.version       = Fastlane::Changelog::VERSION
  spec.author        = %(Pavel Prochazka)
  spec.email         = %(pprochazka72@gmail.com)

  spec.summary       = %(Automate changes to your project CHANGELOG.md)
  spec.homepage      = "https://github.com/pajapro/fastlane-plugin-changelog"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w[README.md LICENSE]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fastlane', '>= 2.0.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
