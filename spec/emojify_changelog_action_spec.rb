describe Fastlane::Actions::EmojifyChangelogAction do
  describe 'Emojify output of read_changelog action' do
    let (:changelog_mock_path) { "./../spec/fixtures/CHANGELOG_MOCK.md" }
    let (:existing_section_identifier) { '[0.0.6]' }

    it 'emojify the content of specific section' do
      result = Fastlane::FastFile.new.parse("lane :test do
       	read_changelog(changelog_path: '#{changelog_mock_path}',
       				   section_identifier: '#{existing_section_identifier}')
        emojify_changelog
     	end").runner.execute(:test)

      expect(result).to eq("Added 🎁\n- New awesome feature\n\nChanged ↔️\n- Onboarding flow\n\nFixed ✅\n- Fix Markdown links\n\nRemoved 🚫\n- User tracking\n\nWork In Progress 🚧\n- Sales screen\n\nSecurity 🔒\n- Enable SSL pinning\n\nDeprecated 💨\n- Obsolete contact screen\n\n")
    end

    # it 'reads content of [Unreleased] section and includes header 3 (###)' do
    #   result = Fastlane::FastFile.new.parse("lane :test do
    #    	read_changelog(changelog_path: '#{changelog_mock_path}',
    #    				   excluded_markdown_elements: '')
    #  	end").runner.execute(:test)

    #   expect(result).to eq("### Added\n- New awesome feature\n\n")
    # end

    # it 'reads content of [Unreleased] section and excludes list elements (-)' do
    #   result = Fastlane::FastFile.new.parse("lane :test do
    #    	read_changelog(changelog_path: '#{changelog_mock_path}',
    #    				   excluded_markdown_elements: '-')
    #  	end").runner.execute(:test)

    #   expect(result).to eq("### Added\nNew awesome feature\n\n")
    # end

    # it 'reads content of [Unreleased] section and excludes list elements (-) and header 3 (###)' do
    #   result = Fastlane::FastFile.new.parse("lane :test do
    #    	read_changelog(changelog_path: '#{changelog_mock_path}',
    #    				   excluded_markdown_elements: ['-', '###'])
    #  	end").runner.execute(:test)

    #   expect(result).to eq("Added\nNew awesome feature\n\n")
    # end
  end
end
