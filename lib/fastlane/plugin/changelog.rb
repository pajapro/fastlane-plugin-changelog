require 'fastlane/plugin/changelog/version'

module Fastlane
  module Changelog
    CHANGELOG_PATH = './CHANGELOG.md'
    DEFAULT_CHANGELOG = '# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Your awesome new feature'

    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end

    # Offer user to setup CHANGELOG.md file in project folder (unless it already exists)
    def self.setup_changelog
      unless has_changelog?
        if FastlaneCore::UI.confirm('Your project folder does not have CHANGELOG.md - do you want to create one now?')
          create_changelog

          FastlaneCore::UI.message('Changelog plugin can automaticaly create a link for comparison between two tags (see https://github.com/pajapro/fastlane-plugin-changelog#--stamp_changelog)')
          if FastlaneCore::UI.confirm('Do you want to create links for comparing tags?')
            repo_url = FastlaneCore::UI.input('Enter your GitHub or Bitbucket repository URL (e.g.: https://github.com/owner/project or https://bitbucket.org/owner/project):')
            create_comparison_link(repo_url)
          else
            write_to_changelog(DEFAULT_CHANGELOG)
          end
        end
      end
    end

    # Does CHANGELOG.md exists in project folder?
    def self.has_changelog?
      File.exist?(CHANGELOG_PATH)
    end

    # Create CHANGELOG.md file
    def self.create_changelog
      FileUtils.touch 'CHANGELOG.md'
    end

    # Create a link for tag comparison
    def self.create_comparison_link(repo_url)
      if repo_url.start_with?('https://github.com')
        output = DEFAULT_CHANGELOG + "\n\n[Unreleased]: #{repo_url}/compare/master...HEAD"
        write_to_changelog(output)
      elsif repo_url.start_with?('https://bitbucket.org')
        output = DEFAULT_CHANGELOG + "\n\n[Unreleased]: #{repo_url}/compare/master..HEAD"
        write_to_changelog(output)
      else
        FastlaneCore::UI.error('Unknown repository host')
        FastlaneCore::UI.message('Creating CHANGELOG.md without links for comparing tags')
        write_to_changelog(DEFAULT_CHANGELOG)
      end
    end

    # Write given content to CHANGELOG.md
    def self.write_to_changelog(changelog)
      File.open(CHANGELOG_PATH, 'w') { |f| f.write(changelog) }
      FastlaneCore::UI.success('Successfuly created CHANGELOG.md')
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Changelog.all_classes.each do |current|
  require current
end

# By default we want to ensure CHANGELOG.md is present
Fastlane::Changelog.setup_changelog
