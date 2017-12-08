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

  attr_reader :changelogs

  def initialize
    @changelogs = []
    collect_changelog_data
  end

  private

  def collect_changelog_data
    changelog_file = read_changelog
    parse_changelog(changelog_file)
  end

  def read_changelog
    File.exist?('CHANGELOG.md') ? File.read('CHANGELOG.md') : ''
  end

  def parse_changelog(file)
    log_entry = nil
    file.each_line do |line|
      h = header_line(line)
      e = entry_line(line)
      log_entry = evaluate_log_entry(log_entry, h, e)
    end
    @changelogs << log_entry
  end

  def evaluate_log_entry(log_entry, h, e)
    if log_entry.nil?
      h.present? ? log_entry = ChangelogEntry.new(h) : log_entry
    elsif h.present?
      log_entry = add_and_get_new_entry(log_entry, h)
    elsif e.present?
      log_entry.add(e)
    end
    log_entry
  end

  def add_and_get_new_entry(log_entry, h)
    @changelogs << log_entry
    ChangelogEntry.new(h)
  end

  def header_line(h)
    h.strip!
    h[/^## [^\s]+ ((\d+\.)+(\d+))$/i, 1]
  end

  def entry_line(e)
    e.strip!
    e[/^\*\s*(.*)/, 1]
  end
end
