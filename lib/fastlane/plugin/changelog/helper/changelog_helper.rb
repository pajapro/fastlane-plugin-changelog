module Fastlane
  module Helper
    CHANGELOG_PATH = './CHANGELOG.md'
    DEFAULT_CHANGELOG = '# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Your awesome new feature'

    class ChangelogHelper

      # Ensures CHANGELOG.md exists at given path. If not, offers to create a default one.
      def self.ensure_changelog_exists(path)
        if File.exist?(path)
          FastlaneCore::UI.success "Found CHANGELOG.md at #{path}"
        else 
          generate_changelog  
        end
      end

      # Generates CHANGELOG.md in project root
      def self.generate_changelog
        if FastlaneCore::UI.confirm('Your project folder does not have CHANGELOG.md - do you want to create one now?')
            FileUtils.touch 'CHANGELOG.md'
            generate_comparison_link
        else 
            FastlaneCore::UI.error("Cannot continue without CHANGELOG.md file")
        end
      end

      # Generates link for tag comparison
      def self.generate_comparison_link     
        FastlaneCore::UI.message('Changelog plugin can automaticaly create a link for comparison between two tags (see https://github.com/pajapro/fastlane-plugin-changelog#--stamp_changelog)')
        if FastlaneCore::UI.confirm('Do you want to create links for comparing tags?')
          repo_url = FastlaneCore::UI.input('Enter your GitHub or Bitbucket repository URL (e.g.: https://github.com/owner/project or https://bitbucket.org/owner/project):')
          compose_comparison_link(repo_url)
        else
          write_to_changelog(DEFAULT_CHANGELOG)
        end
      end

      # Composes link for tag comparison for GitHub or Bitbucket
      def self.compose_comparison_link(repo_url)
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

      # Writes given content to CHANGELOG.md in project root
      def self.write_to_changelog(changelog)
        File.open(CHANGELOG_PATH, 'w') { |f| f.write(changelog) }
        FastlaneCore::UI.success('Successfuly created CHANGELOG.md')
      end
      
      def self.get_line_separator(file_path)
        f = File.open(file_path)
        enum = f.each_char
        c = enum.next
        loop do
          case c[/\r|\n/]
          when "\n" then break
          when "\r"
            c << "\n" if enum.peek == "\n"
            break
          end
          c = enum.next
        end
        c[0][/\r|\n/] ? c : "\n"
      end
    end
  end
end
