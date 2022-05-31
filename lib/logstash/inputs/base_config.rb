class BaseConfig

  attr_reader :base_url, :username, :api_key

  def initialize(config_hash)
    @base_url = config_hash.fetch('base_url')
    @username = config_hash.fetch('username')
    @api_key = config_hash.fetch('api_key')
  end
end
