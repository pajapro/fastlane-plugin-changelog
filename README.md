# changelog plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-changelog)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-changelog`, add it to your project by running:

```bash
fastlane add_plugin changelog
```

## About changelog

This plugin is inspired by and based on [Keep a CHANGELOG](http://keepachangelog.com/) project. [Keep a CHANGELOG](http://keepachangelog.com/) proposes a standardised format for keeping change log of your project repository in `CHANGELOG.md` file. This file contains a curated, chronologically ordered list of notable changes for each version of a project in human readable format.

Since [Keep a CHANGELOG](http://keepachangelog.com/) project proposes a well-defined structure with _sections_ (e.g.: `[Unreleased]`, `0.3.0]`) and _subsections_ (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`) it opens up an opportunity to automate reading from/writing to `CHANGELOG.md` with [`fastlane`](https://fastlane.tools). 

## Getting started
1. `cd` to your project folder
2. `touch CHANGELOG.md`
3. open `CHANGELOG.md` in your favourite text editor
4. paste in proposed structure from [What’s a change log?](http://keepachangelog.com/)

## Actions
`fastlane-plugin-changelog` consists of 3 actions enabling you to manipulate `CHANGELOG.md` from [`fastlane`](https://fastlane.tools).

### read_changelog

Reads the content of a section from your project's `CHANGELOG.md` file. `CHANGELOG.md` must follow structure proposed by [Keep a CHANGELOG](http://keepachangelog.com/) project. 

``` ruby
read_changelog	# Reads the Unreleased section from CHANGELOG.md in your project's folder
```

``` ruby
read_changelog(
  changelog_path: './custom_folder/CHANGELOG.md',	# Specify path to CHANGELOG.md
  section_identifier: '[Unreleased]',	# Specify what section to read
  excluded_markdown_elements: '["###"]'	# Specify which markdown elements should be excluded
)
```
 
 Use the output of this action in conjunction with for example [`pilot`](https://github.com/fastlane/fastlane/tree/master/pilot#uploading-builds) to upload your change log to TestFlight or with [`github_release`](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Actions.md#github-releases) to create a new release on Github.

### update_changelog
Updates section identifier of your project's `CHANGELOG.md` file. 
``` ruby
update_changelog(
  section_identifier: "[Build 123]", # Specify what section to update
  updated_section_identifier: "Build 321" # Specify new section identifier
)
```
 
### stamp_changelog
Stamps the _Unreleased_ (see [How can I minimize the effort required?](http://keepachangelog.com/)) section with provided identifier in your project `CHANGELOG.md` file. 
Additionally, you can provide git tag associated with this section. `stamp_changelog` will then create a link to diff between this and previous section's tag on Github. This will enable you to quickly get to [comparison between two tags](https://help.github.com/articles/comparing-commits-across-time/).
``` ruby
stamp_changelog(
  section_identifier: "Build XYZ", # Specify identifier to stamp the Unreleased section with 
  git_tag: "bXYZ" # Specify reference to git tag associated with this section
)
```

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
