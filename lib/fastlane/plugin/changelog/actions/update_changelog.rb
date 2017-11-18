module Fastlane
  module Actions
    class UpdateChangelogAction < Action
      def self.run(params)
        changelog_path = params[:changelog_path] unless params[:changelog_path].to_s.empty?
        UI.error("CHANGELOG.md at path '#{changelog_path}' does not exist") unless File.exist?(changelog_path)

        section_identifier = params[:section_identifier] unless params[:section_identifier].to_s.empty?
        escaped_section_identifier = section_identifier[/\[(.*?)\]/, 1]

        new_section_identifier = params[:updated_section_identifier] unless params[:updated_section_identifier].to_s.empty?
        excluded_placeholder_line = params[:excluded_placeholder_line] unless params[:excluded_placeholder_line].to_s.empty?

        UI.message "Starting to update #{section_identifier} section of '#{changelog_path}'"

        # Read & update file content
        file_content = ""
        found_identifying_section = false

        File.open(changelog_path, "r") do |file|
          line_separator = Helper::ChangelogHelper.get_line_separator(changelog_path)
          file.each_line do |line|

            # 3. Ignore placeholder line (if provided) within the updated section
            if found_identifying_section && !excluded_placeholder_line.nil?
              if isSectionLine(line)
                found_identifying_section = false # Reached the end of section, hence stop reading
              else
                if line =~ /^#{excluded_placeholder_line}/
                  next # Ignore placeholder line, don't output it
                else 
                  file_content.concat(line) # Output unmodified line
                  next
                end
              end
            end

            # 1. Find line matching section identifier
            if line =~ /\#{2}\s?\[#{escaped_section_identifier}\]/
              found_identifying_section = true
            else
              found_identifying_section = false
            end

            # 2. Update section identifier (if found)
            if !new_section_identifier.empty? && found_identifying_section
              section_name = section_identifier[/\[(.*?)\]/, 1]

              line_old = line.dup
              line.sub!(section_name, new_section_identifier)

              if params[:append_date]
                now = Time.now.strftime("%Y-%m-%d")
                line.concat(" - " + now)
                line.delete!(line_separator) # remove line break, because concatenation adds line break between section identifer & date
                line.concat(line_separator) # add line break to the end of the string, in order to start next line on the next line
              end

              UI.message "Old section identifier: #{line_old.delete!("\n")}"
              UI.message "New section identifier: #{line.delete("\n")}"

              # Output updated line
              file_content.concat(line)
              next
            end

            # Output read line
            file_content.concat(line)
          end
        end

        # Write updated content to file
        changelog = File.open(changelog_path, "w")
        changelog.puts(file_content)
        changelog.close
        UI.success("Successfuly updated #{changelog_path}")
      end

      def self.isSectionLine(line)
         line =~ /\#{2}\s?\[.*\]/
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Updates content of a section of your project CHANGELOG.md file"
      end

      def self.details
        "Use this action to update content of an arbitrary section of your project CHANGELOG.md"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :changelog_path,
                                       env_name: "FL_UPDATE_CHANGELOG_PATH_TO_CHANGELOG",
                                       description: "The path to your project CHANGELOG.md",
                                       is_string: true,
                                       default_value: "./CHANGELOG.md",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :section_identifier,
                                       env_name: "FL_UPDATE_CHANGELOG_SECTION_IDENTIFIER",
                                       description: "The unique section identifier to update content of",
                                       is_string: true,
                                       default_value: "[Unreleased]",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Sections (##) in CHANGELOG format must be encapsulated in []") unless value.start_with?("[") && value.end_with?("]")
                                         UI.user_error!("Sections (##) in CHANGELOG format cannot be empty") if value[/\[(.*?)\]/, 1].empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :updated_section_identifier,
                                       env_name: "FL_UPDATE_CHANGELOG_UPDATED_SECTION_IDENTIFIER",
                                       description: "The updated unique section identifier (without square brackets)",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :append_date,
                                       env_name: "FL_UPDATE_CHANGELOG_APPEND_DATE",
                                       description: "Appends the current date in YYYY-MM-DD format after the section identifier",
                                       default_value: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :excluded_placeholder_line,
                                       env_name: "FL_UPDATE_CHANGELOG_EXCLUDED_PLACEHOLDER_LINE",
                                       description: "Placeholder string to be ignored in updated section",
                                       is_string: true,
                                       optional: true)
          # FastlaneCore::ConfigItem.new(key: :updated_section_content,
          #                              env_name: "FL_UPDATE_CHANGELOG_UPDATED_SECTION_CONTENT",
          #                              description: "The updated section content",
          #                              is_string: true,
          #                              optional: true)
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
