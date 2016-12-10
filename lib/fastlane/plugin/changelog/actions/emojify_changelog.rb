module Fastlane
  module Actions
    module SharedValues
      EMOJIFY_CHANGELOG_CONTENT = :EMOJIFY_CHANGELOG_CONTENT
    end

    class EmojifyChangelogAction < Action
      SUBSECTION_IDENTIFIERS = ['Added', 'Changed', 'Fixed', 'Removed', 'Work In Progress', 'Security', 'Deprecated']

      def self.run(params)
        UI.message "Emojifying the output of read_changelog action"

        read_changelog_output = lane_context[SharedValues::READ_CHANGELOG_SECTION_CONTENT]
        changelog_path = lane_context[SharedValues::READ_CHANGELOG_CHANGELOG_PATH]

        line_separator = Helper::ChangelogHelper.get_line_separator(changelog_path)
        emojified_content = ""

        # Read through read changelog output string
        read_changelog_output.each_line do |line|
          # Remove leading or trailing whitespaces
          stripped = line.strip
          # Remove trailing colon (if any)
          if stripped.end_with?(':')
            stripped.chop!
            chopped_colon = true
          end

          if SUBSECTION_IDENTIFIERS.include?(stripped)
            emojified_string = case stripped
                               when 'Added' then 'Added 🎁'
                               when 'Changed' then 'Changed ↔️'
                               when 'Fixed' then 'Fixed ✅'
                               when 'Removed' then 'Removed 🚫'
                               when 'Work In Progress' then 'Work In Progress 🚧'
                               when 'Security' then 'Security 🔒'
                               when 'Deprecated' then 'Deprecated 💨'
                               end

            # Add back trailing colon, if previously removed
            if chopped_colon
              emojified_string.concat(':')
            end

            # Add line break to the end of the string, in order to start next line on the next line
            emojified_string.concat(line_separator)

            # Output updated line
            emojified_content.concat(emojified_string)
          else
            # Output updated line
            emojified_content.concat(line)
          end
        end

        UI.success("Successfuly emojified output of read_changelog action")

        Actions.lane_context[SharedValues::EMOJIFY_CHANGELOG_CONTENT] = emojified_content
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Emojifies the output of read_changelog action"
      end

      def self.details
        "This action uses the output of read_changelog action to append an emoji to known subsections"
      end

      def self.available_options
        []
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
