describe Fastlane::Actions::UpdateChangelogAction do
  describe 'Update CHANGELOG.md with placeholder line action' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK_PLACEHOLDER_SUPPORT.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK_PLACEHOLDER_SUPPORT.md' } # Path to mock CHANGELOG.md with format for placeholders support in [Unreleased] section (https://github.com/dblock/danger-changelog)
    let (:updated_section_identifier) { '12.34.56' }
    let (:existing_section_identifier) { '[0.3.0]' }
    let (:placeholder_line) { '* Your contribution here.' }
    let (:unreleased_identifier) { '[Unreleased]' }

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

    it 'updates [Unreleased] section identifier while excluding placeholder line' do
      # Read what's in [Unreleased] section
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      # Update given section identifier with new one while excluding the placeholder line
      Fastlane::FastFile.new.parse("lane :test do
          update_changelog(changelog_path: '#{changelog_mock_path}',
                           updated_section_identifier: '#{updated_section_identifier}',
                           excluded_placeholder_line: '#{placeholder_line}')
        end").runner.execute(:test)

      # Read updated section
      post_update_read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '[#{updated_section_identifier}]')
        end").runner.execute(:test)

      # Verify placeholder line is excluded
      expect(read_result).not_to eq(post_update_read_result)
      expect(post_update_read_result =~ /^#{placeholder_line}/).to be_falsey
    end

    it 'updates specific section identifier while excluding placeholder line' do
      # Read what's in specified section
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '#{existing_section_identifier}')
        end").runner.execute(:test)

      # Update given section identifier with new one while excluding the placeholder line
      Fastlane::FastFile.new.parse("lane :test do
          update_changelog(changelog_path: '#{changelog_mock_path}',
                           section_identifier: '#{existing_section_identifier}',
                           updated_section_identifier: '#{updated_section_identifier}',
                           excluded_placeholder_line: '#{placeholder_line}')
        end").runner.execute(:test)

      # Read updated section
      post_update_read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '[#{updated_section_identifier}]')
        end").runner.execute(:test)

      # Verify placeholder line is not excluded (section [0.0.3] doesn't have a placeholder line to remove)
      expect(read_result).to eq(post_update_read_result)
      expect(post_update_read_result =~ /^#{placeholder_line}/).to be_falsey
    end
  end
end
