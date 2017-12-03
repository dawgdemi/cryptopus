# Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
# Cryptopus and licensed under the Affero General Public License version 3 or later.
# See the COPYING file at the top-level directory or at
# https://github.com/puzzle/cryptopus.

class ChangelogReader
  class << self
    def changelog
      ChangelogReader.new.changelogs
    end
  end

  def initialize
    @changelogs = []
    collect_changelog_data
  end

  def changelogs
    @changelogs
  end

  private

  def collect_changelog_data
    changelog_file = read_changelog
    parse_changelog_lines(changelog_file)
  end

  def read_changelog
    File.exist?('CHANGELOG.md') ? File.read('CHANGELOG.md') : ''
  end

  def parse_changelog_lines(changelog_file)
    changelog_entry = nil;
    changelog_file.each_line do |line|
      if h = changelog_header_line(line)
	if changelog_entry.present?
	  @changelogs << changelog_entry
	end
        changelog_entry = ChangelogEntry.new(h)
      elsif changelog_entry.present?
        if e = changelog_entry_line(line)
	  changelog_entry.add_change(e)
	end
      end
    end
    if changelog_entry.present?
      @changelogs << changelog_entry
    end
  end

  def changelog_header_line(h)
    h.strip!
    h[/^## [^\s]+ ((\d+\.)+(\d+\.)+(\d+))$/i, 1]
  end

  def changelog_entry_line(e)
    e.strip!
    e[/^\*\s*(.*)/, 1]
  end
end
