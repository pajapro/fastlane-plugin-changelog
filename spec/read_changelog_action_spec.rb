describe Fastlane::Actions::ReadChangelogAction do
  describe 'Read CHANGELOG.md action' do
    let (:changelog_mock_path) { "./fastlane-plugin-changelog/spec/fixtures/CHANGELOG_MOCK.md" }
    let (:existing_section_identifier) { '[0.0.5]' }

    it 'reads content of [Unreleased] section' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}')
     	end").runner.execute(:test)

      expect(result).to eq("Added\n- New awesome feature\n\n")
    end

    it 'reads content of specific section' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}',
       				   section_identifier: '#{existing_section_identifier}')
     	end").runner.execute(:test)

      expect(result).to eq("Added\n- Markdown links to version tags on release headings.\n- Unreleased section to gather unreleased changes and encourage note\nkeeping prior to releases.\n\n")
    end

    it 'reads content of [Unreleased] section and includes header 3 (###)' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}',
       				   excluded_markdown_elements: '')
     	end").runner.execute(:test)

      expect(result).to eq("### Added\n- New awesome feature\n\n")
    end

    it 'reads content of [Unreleased] section and excludes list elements (-)' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}',
       				   excluded_markdown_elements: '-')
     	end").runner.execute(:test)

      expect(result).to eq("### Added\nNew awesome feature\n\n")
    end

    it 'reads content of [Unreleased] section and excludes list elements (-) and header 3 (###)' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}',
       				   excluded_markdown_elements: ['-', '###'])
     	end").runner.execute(:test)

      expect(result).to eq("Added\nNew awesome feature\n\n")
    end
  end
end
