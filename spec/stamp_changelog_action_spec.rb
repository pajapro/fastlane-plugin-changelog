describe Fastlane::Actions::StampChangelogAction do
  describe 'Stamp CHANGELOG.md action' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK.md' }
    let (:changelog_mock_unreleased_path) { './../spec/fixtures/CHANGELOG_MOCK_UNRELEASED.md' }
    let (:changelog_mock_unreleased_path_hook) { './spec/fixtures/CHANGELOG_MOCK_UNRELEASED.md' }
    let (:updated_section_identifier) { '12.34.56' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
      @original_content_unreleased = File.read(changelog_mock_unreleased_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
      File.open(changelog_mock_unreleased_path_hook, 'w') { |f| f.write(@original_content_unreleased) }
    end

    it 'stamps [Unreleased] section with given identifier' do
      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
       	stamp_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '#{updated_section_identifier}')
     	end").runner.execute(:test)

      # Read updated section
      post_stamp_read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '[#{updated_section_identifier}]')
        end").runner.execute(:test)

      expect(read_result).to eq(post_stamp_read_result)
    end

    it 'creates an empty [Unreleased] section' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}')
          end").runner.execute(:test)

      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      expect(read_result).to eq("")
    end

    it 'rejects to stamp empty [Unreleased] section' do
      expect(FastlaneCore::UI).to receive(:important).with("WARNING: No changes in [Unreleased] section to stamp!")

      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}')
          end").runner.execute(:test)

      # Try to stamp [Unreleased] section again, while [Unreleased] section is actually empty
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}')
          end").runner.execute(:test)
    end

    it 'creates tags comparion GitHub link with prefix' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}',
                          git_tag: 'v#{updated_section_identifier}')
          end").runner.execute(:test)

      modified_file = File.read(changelog_mock_path_hook)
      expect(modified_file.lines.last).to eq("[12.34.56]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.3.0...v12.34.56\n")
    end

    it 'creates tags comparion GitHub link with prefix working with [Unreleased] identifiers' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_unreleased_path}',
                          section_identifier: '#{updated_section_identifier}',
                          git_tag: 'v#{updated_section_identifier}')
          end").runner.execute(:test)

      modified_file = File.read(changelog_mock_unreleased_path_hook)
      expect(modified_file.lines.last).to eq("[Unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v12.34.56...HEAD\n")
    end
  end
end
