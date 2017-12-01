class ChangelogEntry
  def initialize(version)
    @version = version
    @changes = []
  end

  def version
    version
  end
 
  def log_entries
    changes
  end

  def add_log_entry(change)
    changes << change
  end
