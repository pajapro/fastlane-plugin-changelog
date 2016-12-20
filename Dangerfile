# Ensure there is a summary for a PR
fail "Please provide a summary in the Pull Request description" if github.pr_body.length < 5

# Only accept PRs to the `develop` branch
fail "Please re-submit this PR to develop, we may have already fixed your issue." if github.branch_for_base != "develop"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Add a CHANGELOG entry for app changes
if !git.modified_files.include?("CHANGELOG.md") && has_app_changes
  fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/pajapro/fastlane-plugin-changelog/blob/master/CHANGELOG.md).")
  message "Note, we hard-wrap at 80 chars and use 2 spaces after the last line."
end