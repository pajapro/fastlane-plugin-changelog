# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [0.5.0] - 2015-09-12
### Added
- Installation wizard in order to help to create the default CHANGELOG.md in project folder [#1](https://github.com/pajapro/fastlane-plugin-changelog/issues/1)

## [0.4.0] - 2015-08-27
### Fixed
- Remove white space following markdown element [#9](https://github.com/pajapro/fastlane-plugin-changelog/issues/9)

### Added
- Unit tests
- The ability to skip stamping when [Unreleased] section is empty [#7](https://github.com/pajapro/fastlane-plugin-changelog/issues/7)

## [0.3.0] - 2015-08-09
### Added
- Possibility to attach current date to section identifier in YYYY/MM/DD format

### Fixed
- `git_tag` argument is not mandatory for `stamp_changelog` action ([issue #5](https://github.com/pajapro/fastlane-plugin-changelog/issues/5))

## [0.2.0] - 2015-06-26
### Added
- `stamp_changelog` action

### Fixed
- robocop corrections

## [0.1.0] - 2015-06-25
### Added
- The initial release

[0.1.0]: https://github.com/pajapro/fastlane-plugin-changelog/releases/tag/v0.1.0
[0.2.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.3.0...v0.4.0
[0.5.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.4.0...v0.5.0
