require_relative 'incremental_config'
require_relative 'full_config'
require_relative 'delete_config'

class ConfigFactory
  def self.get(config_hash)
    config_type = config_hash.fetch('sync_type')
    case config_type
    when 'full'
      return FullConfig.new(config_hash)
    when 'incremental'
      return IncrementalConfig.new(config_hash)
    when 'delete'
      return DeleteConfig.new(config_hash)
    else
      raise "Unexpected sync type: #{config_type}"
    end
  end
end
