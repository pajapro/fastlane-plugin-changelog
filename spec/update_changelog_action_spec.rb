describe Fastlane::Actions::UpdateChangelogAction do
  describe 'Update CHANGELOG.md action' do
    let (:changelog_mock_path) { './spec/fixtures/CHANGELOG_MOCK.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK.md' }
    let (:updated_section_identifier) { '12.34.56' }
    let (:existing_section_identifier) { '[0.0.5]' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
    end

    it 'udpates [Unreleased] section identifier' do
      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      # Update [Unreleased] with another section identifier
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

    it 'udpates specific section identifier' do
      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '#{existing_section_identifier}')
        end").runner.execute(:test)

      # Update given section identifier with another one
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
  end
end
