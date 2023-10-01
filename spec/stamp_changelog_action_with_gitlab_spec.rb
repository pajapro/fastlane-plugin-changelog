describe Fastlane::Actions::StampChangelogAction do
  describe 'Stamp CHANGELOG.md action with GitLab repo' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK_GITLAB.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK_GITLAB.md' }
    let (:updated_section_identifier) { '12.34.56' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
    end

    it 'creates tags comparison for GitLab links' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}',
                          git_tag: 'v#{updated_section_identifier}')
          end").runner.execute(:test)

      post_stamp_file = File.read(changelog_mock_path_hook)
      expect(post_stamp_file.lines.last).to eq("[12.34.56]: https://gitlab.com/olivierlacan/keep-a-changelog/-/compare/v0.3.0...v12.34.56\n")
    end
  end
end
