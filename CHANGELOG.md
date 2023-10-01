# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added:
- Support diff link for GitLab [#58](https://github.com/pajapro/fastlane-plugin-changelog/issues/58)
- Validate last line is in the expected format before using as a template for the diff link
- `:diff_link_format` parameter (for self-hosted or custom domain) supported options `bitbucket` or empty. Empty or not specified assumes GitHub format which others (including GitLab) use.

## [0.16.0] - 2021-03-13
### Added:
- Add new `:stamp_datetime_format` param stamp_changelog action to support custom a user provided date time format ([PR #53](https://github.com/pajapro/fastlane-plugin-changelog/pull/53))

### Changed:
- BREAKING CHANGE: `:stamp_date` param on stamp_changelog action has been renamed to `:should_stamp_date`

### Fixed:
- Fixes some typos of the word "successfully"

## [0.15.0] - 2019-06-33
### Added:
- Missing documentation to read_changelog and emojify_changelog actions ([PR #42](https://github.com/pajapro/fastlane-plugin-changelog/pull/42))

### Changed
- Design of emojify_changelog to support slack message formatting ([PR #43](https://github.com/pajapro/fastlane-plugin-changelog/pull/43))

## [0.14.0] - 2019-03-11
### Added:
- Support for reversed order of tags in diff link for Bitbucket links ([PR #39](https://github.com/pajapro/fastlane-plugin-changelog/pull/39))
- Support for stamping section identifier with _version_ instead of _git tag_ ([PR #39](https://github.com/pajapro/fastlane-plugin-changelog/pull/39))

## [0.13.0] - 2019-02-26
### Fixed:
- Fixed `append_date` parameter of `update_changelog` action ([Issue #40](https://github.com/pajapro/fastlane-plugin-changelog/issues/40))

## [0.12.0] - 2018-11-16
### Fixed:
- Bug when creating git tags comparison link ([Issue #32](https://github.com/pajapro/fastlane-plugin-changelog/issues/32))

## [0.10.0] - 2018-11-11
### Fixed:
- Remove prompt to create `CHANGELOG.md` in project root, while using custom `changelog_path` param ([Issue #28](https://github.com/pajapro/fastlane-plugin-changelog/issues/28) and [Issue #23](https://github.com/pajapro/fastlane-plugin-changelog/issues/23))

## [0.9.0] - 2017-11-25
- Add `placeholder_line` param to `stamp_changelog` action ([feature request #22](https://github.com/pajapro/fastlane-plugin-changelog/issues/22))

## [0.8.0] - 2017-11-11
### Fixed:
- Remove `\n` (newline) from `read_changelog` action's result.

## [0.7.0] - 2017-03-19
### Added:
- Support for Bitbucket tag comparison [Issue #15](https://github.com/pajapro/fastlane-plugin-changelog/issues/15)

## [0.6.2] - 2017-02-12
### Fixed:
- Properly escape section identifiers [PR #18](https://github.com/pajapro/fastlane-plugin-changelog/pull/18) by [PromptWorks](https://www.promptworks.com/)

## [0.6.1] - 2017-01-17
### Fixed:
- Fix stamp_changelog action [PR #17](https://github.com/pajapro/fastlane-plugin-changelog/pull/17)

## [0.6.0] - 2016-12-10
### Added
- New [emojify action](https://github.com/pajapro/fastlane-plugin-changelog/blob/master/README.md#-emojify_changelog)

## [0.5.1] - 2016-11-12
### Fixed
- Fix line separator for CRLF files (issue [#13](https://github.com/pajapro/fastlane-plugin-changelog/issues/13))

## [0.5.0] - 2016-09-12
### Added
- Installation wizard in order to help to create the default CHANGELOG.md in project folder [#1](https://github.com/pajapro/fastlane-plugin-changelog/issues/1)

## [0.4.0] - 2016-08-27
### Fixed
- Remove white space following markdown element [#9](https://github.com/pajapro/fastlane-plugin-changelog/issues/9)

### Added
- Unit tests
- The ability to skip stamping when [Unreleased] section is empty [#7](https://github.com/pajapro/fastlane-plugin-changelog/issues/7)

## [0.3.0] - 2016-08-09
### Added
- Possibility to attach current date to section identifier in YYYY/MM/DD format

### Fixed
- `git_tag` argument is not mandatory for `stamp_changelog` action ([issue #5](https://github.com/pajapro/fastlane-plugin-changelog/issues/5))

## [0.2.0] - 2016-06-26
### Added
- `stamp_changelog` action

### Fixed
- robocop corrections

## [0.1.0] - 2016-06-25
### Added
- The initial release

[0.1.0]: https://github.com/pajapro/fastlane-plugin-changelog/releases/tag/v0.1.0
[0.2.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.3.0...v0.4.0
[0.5.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.4.0...v0.5.0
[0.5.1]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.5.0...v0.5.1
[0.6.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.5.1...v0.6.0
[0.6.1]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.6.0...v0.6.1
[0.6.2]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.6.1...v0.6.2
[0.7.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.6.2...v0.7.0
[0.8.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.7.0...v0.8.0
[0.9.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.8.0...v0.9.0
[0.10.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.9.0...v0.10.0
[0.12.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.10.0...v0.12.0
[0.13.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.12.0...v0.13.0
[0.14.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.13.0...v0.14.0
[0.15.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.14.0...v0.15.0
[0.16.0]: https://github.com/pajapro/fastlane-plugin-changelog/compare/v0.15.0...v0.16.0
