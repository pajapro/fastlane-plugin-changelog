describe Fastlane::Actions::StampChangelogAction do
  describe 'Stamp CHANGELOG.md action' do

  	let (:changelog_mock_path) {'./fastlane-plugin-changelog/spec/fixtures/CHANGELOG_MOCK.md'}
    let (:changelog_mock_path_hook) {'./spec/fixtures/CHANGELOG_MOCK.md'}
    let (:updated_section_identifier) {'12.34.56'}

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do 
      File.open(changelog_mock_path_hook, 'w') {|f| f.write(@original_content) }
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

    it 'creates an empty [Unreleased] section', :now => true do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '#{updated_section_identifier}')
          end").runner.execute(:test)

      # Read what's in [Unreleased]
      read_result = Fastlane::FastFile.new.parse("lane :test do
          read_changelog(changelog_path: '#{changelog_mock_path}')
        end").runner.execute(:test)

      expect(read_result).to eq("\n")
    end
  end
end
