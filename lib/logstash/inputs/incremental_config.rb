require_relative 'full_config'

class IncrementalConfig < FullConfig

  attr_reader :updates_since

  def initialize(config_hash)
    super
    @updates_since = config_hash.fetch('updates_since')
  end
end
