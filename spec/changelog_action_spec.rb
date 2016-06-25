describe Fastlane::Actions::ChangelogAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The changelog plugin is working!")

      Fastlane::Actions::ChangelogAction.run(nil)
    end
  end
end
