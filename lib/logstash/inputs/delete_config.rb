require_relative 'base_config'

class DeleteConfig < BaseConfig

  attr_reader :document_ids

  def initialize(config_hash)
    super
    @document_ids = config_hash.fetch('document_ids')
  end
end
