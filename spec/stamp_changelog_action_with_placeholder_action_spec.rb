describe Fastlane::Actions::StampChangelogAction do
  describe 'Stamp CHANGELOG.md with placeholder line action' do
    let (:changelog_mock_path) { './../spec/fixtures/CHANGELOG_MOCK_PLACEHOLDER_SUPPORT.md' }
    let (:changelog_mock_path_hook) { './spec/fixtures/CHANGELOG_MOCK_PLACEHOLDER_SUPPORT.md' } # Path to mock CHANGELOG.md with format for placeholders support in [Unreleased] section (https://github.com/dblock/danger-changelog)
    let (:updated_section_identifier) { '12.34.56' }
    let (:placeholder_line) { '* Your contribution here.' }

    before(:each) do
      @original_content = File.read(changelog_mock_path_hook)
    end

    after(:each) do
      File.open(changelog_mock_path_hook, 'w') { |f| f.write(@original_content) }
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

    context "stamps [Unreleased] section with given identifier" do
      it 'creates a new section identifier with provided identifier' do
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

      it 'excludes placeholder line' do
        # Stamp [Unreleased] with given section identifier and excludes placeholder line
        Fastlane::FastFile.new.parse("lane :test do
            stamp_changelog(changelog_path: '#{changelog_mock_path}',
                            section_identifier: '#{updated_section_identifier}',
                            placeholder_line: '#{placeholder_line}')
            end").runner.execute(:test)

        # Read updated section
        post_stamp_read_result = Fastlane::FastFile.new.parse("lane :test do
            read_changelog(changelog_path: '#{changelog_mock_path}',
                           section_identifier: '[#{updated_section_identifier}]')
          end").runner.execute(:test)

        expect(post_stamp_read_result).to eq("Added\n* New awesome feature.")
      end

      it 'adds placeholder line to [Unreleased] section after stamping' do
        # Stamp [Unreleased] with given section identifier and provided placeholder line
        Fastlane::FastFile.new.parse("lane :test do
            stamp_changelog(changelog_path: '#{changelog_mock_path}',
                            section_identifier: '#{updated_section_identifier}',
                            placeholder_line: '#{placeholder_line}')
            end").runner.execute(:test)

        # Read updated section
        read_result = Fastlane::FastFile.new.parse("lane :test do
            read_changelog(changelog_path: '#{changelog_mock_path}')
          end").runner.execute(:test)

        expect(read_result).to eq("* Your contribution here.")
      end

      # Combination of the 2 above tests
      it '1. excludes placeholder line in stamped section and 2. adds placeholder line into [Unreleased] section' do
        # Stamp [Unreleased] with given section identifier and excludes placeholder line
        Fastlane::FastFile.new.parse("lane :test do
            stamp_changelog(changelog_path: '#{changelog_mock_path}',
                            section_identifier: '#{updated_section_identifier}',
                            placeholder_line: '#{placeholder_line}')
            end").runner.execute(:test)

        # Read updated section
        stamped_section_read_result = Fastlane::FastFile.new.parse("lane :test do
            read_changelog(changelog_path: '#{changelog_mock_path}',
                           section_identifier: '[#{updated_section_identifier}]')
          end").runner.execute(:test)

        unreleased_section_read_result = Fastlane::FastFile.new.parse("lane :test do
            read_changelog(changelog_path: '#{changelog_mock_path}')
          end").runner.execute(:test)

        expect(stamped_section_read_result).to eq("Added\n* New awesome feature.")
        expect(stamped_section_read_result =~ /^#{placeholder_line}/).to be_falsey
        expect(unreleased_section_read_result).to eq("* Your contribution here.")
      end
    end

    it 'creates tags comparion GitHub link without prefix' do
      # Stamp [Unreleased] with given section identifier
      Fastlane::FastFile.new.parse("lane :test do
          stamp_changelog(changelog_path: '#{changelog_mock_path}',
                          section_identifier: '3.11.1',
                          git_tag: '3.11.1')
          end").runner.execute(:test)

      modified_file = File.read(changelog_mock_path_hook)
      expect(modified_file.lines.last).to eq("[3.11.1]: https://github.com/olivierlacan/keep-a-changelog/compare/3.11.0...3.11.1\n")
    end
  end
end
