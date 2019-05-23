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

      expect(result).to eq("*Added* 🎁\n• New awesome feature\n\n*Changed* ↔️\n• Onboarding flow\n\n*Fixed* ✅\n• Fix Markdown links\n\n*Removed* 🚫\n• User tracking\n\n*Work In Progress* 🚧\n• Sales screen\n\n*Security* 🔒\n• Enable SSL pinning\n\n*Deprecated* 💨\n• Obsolete contact screen")
    end
  end
end
