describe Fastlane::Actions::UpdateChangelogAction do
  describe 'Update CHANGELOG.md action' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK.md' }
    let (:updated_section_identifier) { '12.34.56' }
    let (:existing_section_identifier) { '[0.0.5]' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
    end

    it 'updates [Unreleased] section identifier' do
      # Read what's in [Unreleased] section
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      # Update [Unreleased] section identifier with new one
      Fastlane::FastFile.new.parse("lane :test do
       	update_changelog(changelog_path: '#{changelog_mock_path}',
                          updated_section_identifier: '#{updated_section_identifier}')
     	end").runner.execute(:test)

      # Read updated section
      post_update_read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '[#{updated_section_identifier}]')
        end").runner.execute(:test)

      expect(read_result).to eq(post_update_read_result)
    end

    it 'updates specific section identifier' do
      # Read what's in specified section
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '#{existing_section_identifier}')
        end").runner.execute(:test)

      # Update given section identifier with new one
      Fastlane::FastFile.new.parse("lane :test do
          update_changelog(changelog_path: '#{changelog_mock_path}',
                           section_identifier: '#{existing_section_identifier}',
                           updated_section_identifier: '#{updated_section_identifier}')
        end").runner.execute(:test)

      # Read updated section
      post_update_read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '[#{updated_section_identifier}]')
        end").runner.execute(:test)

      expect(read_result).to eq(post_update_read_result)
    end

    it 'updates [Unreleased] section identifier without appending a date' do
      # Update [Unreleased] section identifier with new one - explicitly ask to not use a date.
      Fastlane::FastFile.new.parse("lane :test do
        update_changelog(changelog_path: '#{changelog_mock_path}',
                          updated_section_identifier: '#{updated_section_identifier}',
                          should_append_date: false)
      end").runner.execute(:test)

      # Read updated section line
      modifiedSectionLine = ""
      File.open(changelog_mock_path_hook, "r") do |file|
        file.each_line do |line|
            if line =~ /\#{2}\s?\[#{updated_section_identifier}\]/
              modifiedSectionLine = line
            break
          end
        end
      end

      # Expect the modified section line to be without date
      expect(modifiedSectionLine).to eq("## [12.34.56]\n")
    end

    it 'updates [Unreleased] section identifier appending a date via the default datetime format' do
      # Update [Unreleased] section identifier with new one via the default datetime format
      Fastlane::FastFile.new.parse("lane :test do
        update_changelog(changelog_path: '#{changelog_mock_path}',
                         updated_section_identifier: '#{updated_section_identifier}')
      end").runner.execute(:test)

      # Read updated section line
      modifiedSectionLine = ""
      File.open(changelog_mock_path_hook, "r") do |file|
        file.each_line do |line|
            if line =~ /\#{2}\s?\[#{updated_section_identifier}\]/
              modifiedSectionLine = line
            break
          end
        end
      end

      # Expect the modified section line to be with current date
      now = Time.now.utc.strftime("%FZ")
      expect(modifiedSectionLine).to eq("## [12.34.56] - #{now}\n")
    end

    it 'updates [Unreleased] section identifier appending a date via a user specified datetime format' do
      # Update [Unreleased] section identifier with new one via the user specified datetime format
      Fastlane::FastFile.new.parse("lane :test do
        update_changelog(changelog_path: '#{changelog_mock_path}',
                          updated_section_identifier: '#{updated_section_identifier}',
                          append_datetime_format: '%FT%TZ')
      end").runner.execute(:test)

      # Read updated section line
      modifiedSectionLine = ""
      File.open(changelog_mock_path_hook, "r") do |file|
        file.each_line do |line|
            if line =~ /\#{2}\s?\[#{updated_section_identifier}\]/
              modifiedSectionLine = line
            break
          end
        end
      end

      # Expect the modified section line to be with current date
      now = Time.now.utc.strftime("%FT%TZ")
      expect(modifiedSectionLine).to eq("## [12.34.56] - #{now}\n")
    end
  end
end
