# changelog plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-changelog)  [![Build Status](https://travis-ci.org/pajapro/fastlane-plugin-changelog.svg?branch=master)](https://travis-ci.org/pajapro/fastlane-plugin-changelog)  [![Twitter: @hello_paja](https://img.shields.io/badge/contact-@Hello_Paja-blue.svg?style=flat)](https://twitter.com/hello_paja)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-changelog` add it to your project by running:

```bash
fastlane add_plugin changelog
```

## About changelog

This plugin is inspired by and based on [Keep a CHANGELOG](http://keepachangelog.com/) project. [Keep a CHANGELOG](http://keepachangelog.com/) proposes a standardised format for keeping change log of your project repository in `CHANGELOG.md` file. This file contains a curated, chronologically ordered list of notable changes for each version of a project in human readable format.

Since [Keep a CHANGELOG](http://keepachangelog.com/) project proposes a well-defined structure with _sections_ (e.g.: `[Unreleased]`, `[0.3.0]`) and _subsections_ (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`) it opens up an opportunity to automate reading from/writing to `CHANGELOG.md` with [`fastlane`](https://fastlane.tools). 

## Actions
`fastlane-plugin-changelog` consists of 3 actions enabling you to manipulate `CHANGELOG.md` from [`fastlane`](https://fastlane.tools).

### 📖  read_changelog

Reads the content of a section from your project's `CHANGELOG.md` file. `CHANGELOG.md` must follow structure proposed by [Keep a CHANGELOG](http://keepachangelog.com/) project. 

``` ruby
read_changelog	# Reads the Unreleased section from CHANGELOG.md in your project's folder
```

``` ruby
read_changelog(
  changelog_path: './custom_folder/CHANGELOG.md',	# Specify path to CHANGELOG.md
  section_identifier: '[Unreleased]',	# Specify what section to read
  excluded_markdown_elements: ['-', '###']	# Specify which markdown elements should be excluded
)
```
 
 Use the output of this action in conjunction with for example [`pilot`](https://github.com/fastlane/fastlane/tree/master/pilot#uploading-builds) to upload your change log to TestFlight or with [`github_release`](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Actions.md#github-releases) to create a new release on Github.

### 📝  update_changelog
Updates section identifier of your project's `CHANGELOG.md` file. 
``` ruby
update_changelog(
  section_identifier: '[Build 123]', # Specify what section to update
  updated_section_identifier: 'Build 321' # Specify new section identifier
)
```
 
### 🔖  stamp_changelog
Stamps the _Unreleased_ (see [How can I minimize the effort required?](http://keepachangelog.com/)) section with provided identifier in your project `CHANGELOG.md` file and sets up a new _Unreleased_ section above it.
Additionally, you can provide an optional `git_tag` param, specifing git tag associated with this section. `stamp_changelog` will then create a link to diff between this and previous section's tag on GitHub or Bitbucket. This will enable you to quickly get to [comparison between two tags](https://help.github.com/articles/comparing-commits-across-time/).
``` ruby
stamp_changelog(
  section_identifier: 'Build XYZ', # Specify identifier to stamp the Unreleased section with 
  git_tag: 'bXYZ', # Specify reference to git tag associated with this section
  should_stamp_date: true, # Specify whether the current date as per the stamp_datetime_format should be stamped to the section identifier (default is `true`)
  stamp_datetime_format: '%FT%TZ' # Specify strftime format string to use for the date in the stamped section (default `%FZ`)
)
```

🤖 Moreover, if you are using [danger-changelog](https://github.com/dblock/danger-changelog) plugin, you can leverage `placeholder_line` string paramater. `placeholder_line` string will be ignored when stamping an existing section _and_ copied into `[Unreleased]` section. This will help contributors to your project to see where changelog changes should be added (see [feature request](https://github.com/pajapro/fastlane-plugin-changelog/issues/22)). 

### 😁 emojify_changelog
Emojifies the output of `read_changelog` action. When you share changelog with the rest of your team on e.g.: Slack channel, it's nice to sprinkle your subsections with a bit of visuals so it immediately catches eyes of your teammates. `emojify_changelog` uses the output of `read_changelog` action to append an emoji to known subsections, for example:

```
Added:
- New awesome feature

Changed:
- Onboarding flow 

Fixed:
- Fix Markdown links 

Removed:
- User tracking 

Work In Progress:
- Sales screen

Security:
- Enable SSL pinning

Deprecated:
- Obsolete contact screen
```

emojifies into:

```
*Added* 🎁:
• New awesome feature

*Changed* ↔️:
• Onboarding flow UI

*Fixed* ✅:
• Fix Markdown links 

*Removed* 🚫:
• User tracking 

*Work In Progress* 🚧:
• Sales screen

*Security* 🔒:
• Enable SSL pinning

*Deprecated* 💨:
• Obsolete contact screen
```

Example of use:
``` ruby
changelog = read_changelog # Read changelog
pilot(changelog: changelog) # Send binary and changelog to TestFlight
emojified_changelog = emojify_changelog # Emojify the output of `read_changelog` action
slack(message: "Hey team, we have a new build for you, which includes the following: #{emojified_changelog}") # share on Slack
```

*NOTE*: do not send emojified changelog to iTunes Connect as it cannot handle emojis. 

## Example
As a developer you have to **remember to keep your CHANGELOG.md up-to-date** with whatever features, bug fixes etc. your repo contains and let [`fastlane`](https://fastlane.tools) do the rest. 

``` ruby
lane :beta do
  build_number = get_build_number # Get build number
  gym # Compile
  
  changelog = read_changelog # Read changelog
  pilot(changelog: changelog) # Send binary and changelog to TestFlight
  
  stamp_changelog(section_identifier: "Build #{build_number}") # Stamp Unreleased section with newly released build number
end
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
