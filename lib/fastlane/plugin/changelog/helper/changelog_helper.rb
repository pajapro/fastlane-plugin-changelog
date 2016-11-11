module Fastlane
  module Helper
    class ChangelogHelper
      # class methods that you define here become available in your action
      # as `Helper::ChangelogHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the changelog plugin helper!")
      end

      def self.get_line_separator(file_path)
        f = File.open(file_path)
        enum = f.each_char
        c = enum.next
        loop do
          case c[/\r|\n/]
          when "\n" then break
          when "\r"
            c << "\n" if enum.peek == "\n"
            break
          end
          c = enum.next
        end
        c[0][/\r|\n/] ? c : "\n"
      end
    end
  end
end
