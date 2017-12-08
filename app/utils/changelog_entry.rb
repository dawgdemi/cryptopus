class ChangelogEntry
  def initialize(version)
    @version = version
    @changes = []
  end

  def version
    @version
  end
 
  def log_entries
    @changes
  end

  def add_change(change)
    @changes << change
  end
end
