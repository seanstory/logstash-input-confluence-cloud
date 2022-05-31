require_relative 'full_config'

class IncrementalConfig < FullConfig

  attr_reader :updates_since

  def initialize(config_hash)
    super
    @updates_since = config_hash.fetch('updates_since')
    begin
      Time.parse(@updates_since)
    rescue => e
      raise LogStash::ConfigurationError.new("Failed to parse `updates_since` as a timestamp", e)
    end
  end
end
