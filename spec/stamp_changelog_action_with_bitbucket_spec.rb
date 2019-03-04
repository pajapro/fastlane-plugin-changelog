describe Fastlane::Actions::StampChangelogAction do
  describe 'Stamp CHANGELOG.md action with Bitbucket repo' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK_BITBUCKET.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK_BITBUCKET.md' }
    let (:updated_section_identifier) { '12.34.56' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
    end

    it 'use correct identifier when stamping [Unreleased] section' do
      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      pre_stamp_file = File.read(changelog_mock_path_hook)
      expect(pre_stamp_file).not_to include("## [#{updated_section_identifier}]")

      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
       	stamp_changelog(changelog_path: '#{changelog_mock_path}',
                         section_identifier: '#{updated_section_identifier}')
     	end").runner.execute(:test)

      # Read post-stamp file
      post_stamp_file = File.read(changelog_mock_path_hook)

      expect(post_stamp_file).to include("## [#{updated_section_identifier}]")
    end

    it 'creates reversed tags comparison for Bitbucket links' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}',
                          git_tag: 'v#{updated_section_identifier}')
          end").runner.execute(:test)

      post_stamp_file = File.read(changelog_mock_path_hook)
      expect(post_stamp_file.lines.last).to eq("[12.34.56]: https://bitbucket.org/repo/keep-a-changelog/branches/compare/v12.34.56..v0.3.0\n")
    end
  end
end
