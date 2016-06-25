module Fastlane
  module Helper
    class ChangelogHelper
      # class methods that you define here become available in your action
      # as `Helper::ChangelogHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the changelog plugin helper!")
      end
    end
  end
end
