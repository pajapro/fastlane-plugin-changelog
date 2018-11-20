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
          stamp_date = params[:stamp_date]
          git_tag = params[:git_tag]
          placeholder_line = params[:placeholder_line]

          stamp(changelog_path, section_identifier, stamp_date, git_tag, placeholder_line)
        end
      end

      def self.stamp(changelog_path, section_identifier, stamp_date, git_tag, placeholder_line)
        # 1. Update [Unreleased] section with given identifier
        Actions::UpdateChangelogAction.run(changelog_path: changelog_path,
                                           section_identifier: UNRELEASED_IDENTIFIER,
                                           updated_section_identifier: section_identifier,
                                           append_date: stamp_date,
                                           excluded_placeholder_line: placeholder_line)

        file_content = ""
        last_line = ""

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
            file_content.concat(last_line)
            last_line = line
          end
        end

        # 3. Create link to git tags diff
        if !git_tag.nil? && !git_tag.empty?
          git = ''
          previous_tag = ""
          previous_previous_tag = ""

          if last_line.include? 'https://github.com' or last_line.include? 'http://gitlab.' # GitHub and Gitlab use compare/olderTag...newerTag structure
            git = 1
            previous_previous_tag = %r{(?<=compare\/)(.*)?(?=\.{3})}.match(last_line).to_s
            previous_tag = %r{(?<=\.{3})(.*)?}.match(last_line)
          elsif last_line.include? 'https://bitbucket.org' # Bitbucket uses compare/newerTag..olderTag structure
            git = 2
            previous_previous_tag = %r{(?<=\.{2})(.*)?}.match(last_line).to_s
            previous_tag = %r{(?<=compare\/)(.*)?(?=\.{2})}.match(last_line)
          end

          if last_line.include? UNRELEASED_IDENTIFIER
            if git == 1
              last_line.sub!("...HEAD", "...#{git_tag}")
              last_line.sub!(UNRELEASED_IDENTIFIER, "[#{section_identifier}]")

              file_content.concat(last_line)


              # Using the modified line to create a new [Unreleased] line
              last_line.sub!("...#{git_tag}", "...HEAD")
              last_line.sub!("[#{section_identifier}]", UNRELEASED_IDENTIFIER)
              last_line.sub!("#{previous_previous_tag}...", "#{git_tag}...")

              file_content.concat(last_line)

            elsif git == 2
              last_line.sub!("HEAD...", "#{git_tag}...")
              last_line.sub!(UNRELEASED_IDENTIFIER, "[#{section_identifier}]")

              file_content.concat(last_line)

              last_line.sub!("#{git_tag}...", "HEAD...")
              last_line.sub!("[#{section_identifier}]", UNRELEASED_IDENTIFIER)
              last_line.sub!("...#{previous_previous_tag}", "...#{git_tag}")

              file_content.concat(last_line)
            end
          else
            file_content.concat(last_line)

            # Replace section identifier
            cleared_git_tag = git_tag.delete('[a-z]')
            cleared_previous_git_tag = previous_tag.to_s.delete('[a-z]')
            last_line.sub!("[#{cleared_previous_git_tag}]", "[#{cleared_git_tag}]")

            # Replace previous-previous tag with previous
            last_line.sub!(previous_previous_tag.to_s, previous_tag.to_s)

            # Replace previous tag with new
            last_line.sub!("..#{previous_tag}", "..#{git_tag}")

            UI.message("Created a link for comparison between #{previous_tag} and #{git_tag} tag")

            file_content.concat(last_line)
          end

          UI.message("Updated the link for comparison between #{previous_previous_tag} and #{git_tag} tag")
          UI.message("Created a link for comparison between #{git_tag} and HEAD tag")
        else
          file_content.concat(last_line)
        end

        # 4. Write updated content to file
        changelog = File.open(changelog_path, "w")
        changelog.puts(file_content)
        changelog.close
        UI.success("Successfuly stamped #{section_identifier} in #{changelog_path}")
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
            FastlaneCore::ConfigItem.new(key: :stamp_date,
                                         env_name: "FL_STAMP_CHANGELOG_SECTION_STAMP_DATE",
                                         description: "Specifies whether the current date should be appended to section identifier",
                                         default_value: true,
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
