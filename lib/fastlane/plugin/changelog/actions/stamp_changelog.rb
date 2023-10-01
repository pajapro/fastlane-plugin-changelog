module Fastlane
  module Actions
    class StampChangelogAction < Action
      UNRELEASED_IDENTIFIER = '[Unreleased]'

      def self.run(params)
        # 1. Ensure CHANGELOG.md exists
        changelog_path = params[:changelog_path] unless params[:changelog_path].to_s.empty?
        changelog_path = Helper::ChangelogHelper.ensure_changelog_exists(changelog_path)

        # 2. Ensure there are changes in [Unreleased] section
        unreleased_section_content = Actions::ReadChangelogAction.run(changelog_path: changelog_path, section_identifier: UNRELEASED_IDENTIFIER, excluded_markdown_elements: ["###"])
        if unreleased_section_content.eql?("")
          UI.important("WARNING: No changes in [Unreleased] section to stamp!")
        else
          section_identifier = params[:section_identifier] unless params[:section_identifier].to_s.empty?
          should_stamp_date = params[:should_stamp_date]
          stamp_datetime_format = params[:stamp_datetime_format]
          git_tag = params[:git_tag]
          placeholder_line = params[:placeholder_line]
          diff_link_format = params[:diff_link_format]

          stamp(changelog_path, section_identifier, should_stamp_date, stamp_datetime_format, git_tag, placeholder_line, diff_link_format)
        end
      end

      def self.stamp(changelog_path, section_identifier, should_stamp_date, stamp_datetime_format, git_tag, placeholder_line, diff_link_format)
        # 1. Update [Unreleased] section with given identifier
        Actions::UpdateChangelogAction.run(changelog_path: changelog_path,
                                          section_identifier: UNRELEASED_IDENTIFIER,
                                          updated_section_identifier: section_identifier,
                                          should_append_date: should_stamp_date,
                                          append_datetime_format: stamp_datetime_format,
                                          excluded_placeholder_line: placeholder_line)

        file_content = ""

        # 2. Create new [Unreleased] section (placeholder)
        inserted_unreleased = false
        File.open(changelog_path, "r") do |file|
          file.each_line do |line|
            # Find the first section identifier
            if !inserted_unreleased && line =~ /\#{2}\s?\[(.*?)\]/
              unreleased_section = "## [Unreleased]"

              # Insert placeholder line (if provided)
              if !placeholder_line.nil? && !placeholder_line.empty?
                line = "#{unreleased_section}\n#{placeholder_line}\n\n#{line}"
              else
                line = "#{unreleased_section}\n\n#{line}"
              end

              inserted_unreleased = true

              UI.message("Created [Unreleased] placeholder section")

              # Output updated line
              file_content.concat(line)
              next
            end

            # Output read line
            file_content.concat(line)
          end
        end

        # 3. Create link to git tags diff
        if !git_tag.nil? && !git_tag.empty?
          last_line = file_content.lines.last
          
          # if the last line matches the `[new] http...compare/{old}..{new}` format
          if last_line.match(/\[.+\]: http.+compare\/.+\.{2,3}.+/)
            previous_tag = ''
            previous_previous_tag = ''
            reversed_tags = false

            if diff_link_format == 'bitbucket' or last_line.include? 'https://bitbucket.org'
              # Bitbucket uses compare/newerTag..olderTag structure
              reversed_tags = true
              previous_tag = %r{(?<=compare\/)(.*)?(?=\.{2})}.match(last_line)
              previous_previous_tag = /(?<=\.{2})(.*)?/.match(last_line)
            else
              # GitHub/GitLab uses compare/olderTag...newerTag structure
              previous_previous_tag = %r{(?<=compare\/)(.*)?(?=\.{3})}.match(last_line)
              previous_tag = /(?<=\.{3})(.*)?/.match(last_line)
            end

            # Replace section identifier
            previous_section_identifier = /(?<=\[)[^\]]+(?=\]:)/.match(last_line)
            last_line.sub!("[#{previous_section_identifier}]:", "[#{section_identifier}]:")

            if !previous_tag.nil? && !previous_previous_tag.nil?
              # Replace first tag
              last_line.sub!(
                reversed_tags ? previous_tag.to_s : previous_previous_tag.to_s,
                reversed_tags ? git_tag.to_s : previous_tag.to_s
              )
              # Replace second tag
              last_line.sub!(
                "..#{reversed_tags ? previous_previous_tag : previous_tag}",
                "..#{reversed_tags ? previous_tag : git_tag}"
              )
              file_content.concat(last_line)
              UI.message("Created a link for comparison between #{previous_tag} and #{git_tag} tag")
            end

          else
            UI.important("WARNING: Last line does not match the expected format: https://github.com/[user]/[project]/compare/[oldTag]...[newTag]")
          end

        end

        # 4. Write updated content to file
        changelog = File.open(changelog_path, "w")
        changelog.puts(file_content)
        changelog.close
        UI.success("Successfully stamped #{section_identifier} in #{changelog_path}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Stamps the [Unreleased] section with provided identifier in your project CHANGELOG.md file"
      end

      def self.details
        "Use this action to stamp the [Unreleased] section with provided identifier in your project CHANGELOG.md. Additionally, you can provide git tag
        associated with this section. `stamp_changelog` will then create a new link to diff between this and previous section's tag on Github"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :changelog_path,
                                       env_name: "FL_CHANGELOG_PATH",
                                       description: "The path to your project CHANGELOG.md",
                                       is_string: true,
                                       default_value: "./CHANGELOG.md",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :section_identifier,
                                       env_name: "FL_STAMP_CHANGELOG_SECTION_IDENTIFIER",
                                       description: "The unique section identifier to stamp the [Unreleased] section with",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :should_stamp_date,
                                       env_name: "FL_STAMP_CHANGELOG_SHOULD_STAMP_DATE",
                                       description: "Specifies whether the current date as per the stamp_datetime_format should be stamped to the section identifier",
                                       default_value: true,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :stamp_datetime_format,
                                       env_name: "FL_STAMP_CHANGELOG_DATETIME_FORMAT",
                                       description: "The strftime format string to use for the date in the stamped section",
                                       default_value: '%FZ',
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :git_tag,
                                       env_name: "FL_STAMP_CHANGELOG_GIT_TAG",
                                       description: "The git tag associated with this section",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :placeholder_line,
                                       env_name: "FL_STAMP_CHANGELOG_PLACEHOLDER_LINE",
                                       description: "The placeholder line to be excluded in stamped section and added to [Unreleased] section",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :diff_link_format,
                                       env_name: "FL_STAMP_CHANGELOG_DIFF_LINK_FORMAT",
                                       description: "The diff link format: `bitbucket` or empty for GitHub & GitLab",
                                       is_string: true,
                                       default_value: "",
                                       optional: true)
        ]
      end

      def self.authors
        ["pajapro"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
