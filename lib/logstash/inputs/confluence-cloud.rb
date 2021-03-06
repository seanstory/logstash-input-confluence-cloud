# encoding: utf-8
require 'logstash/inputs/base'
require 'stud/interval'
require 'connectors_sdk'
require 'time'
require_relative '../../initializers/01_hashie'
require_relative 'config_factory'
require_relative 'delete_config'
require_relative 'full_config'
require_relative 'incremental_config'


class LogStash::Inputs::ConfluenceCloud < LogStash::Inputs::Base
  config_name 'confluence-cloud'

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, 'plain'

  config :connector_config, :validate => :hash, :required => true

  public
  def register
    @connector_config = ConfigFactory.get(@connector_config)
    @confluence_client = ConnectorsSdk::ConfluenceCloud::CustomClient.new(
      :base_url => @connector_config.base_url,
      :access_token => nil,
      :basic_auth_token => basic_auth_token(@connector_config.username, @connector_config.api_key)
    )
  end # def register

  def run(queue)
    Time.zone_default = Time.find_zone!('UTC')
    if @connector_config.is_a?(FullConfig) || @connector_config.is_a?(IncrementalConfig)
      extractor.document_changes(:modified_since => @connector_config.updates_since) do |action, document_or_es_id, _b|
        if stop?
          break
        end
        event = LogStash::Event.new(document_or_es_id.merge(:action => action))
        decorate(event)
        queue << event
      end
    elsif @connector_config.is_a?(DeleteConfig)
      extractor.deleted_ids(@connector_config.document_ids) do |id|
        purge_document = { :id => id, :action => 'delete' }
        event = LogStash::Event.new(purge_document)
        decorate(event)
        queue << event
      end
    else
      raise "Unexpected config class #{@connector_config.class}"
    end
  end

  private

  def basic_auth_token(username, password)
    Base64.encode64("#{username}:#{password}").gsub(/\s/,'')
  end

  def extractor
    @extractor ||= ConnectorsSdk::ConfluenceCloud::Extractor.new(
      content_source_id: "GENERATED-#{BSON::ObjectId.new}",
      service_type: 'confluence_cloud',
      authorization_data_proc: proc do
        {
          :base_url => @connector_config.base_url.to_s,
          :access_token => nil,
          :basic_auth_token => basic_auth_token(@connector_config.username, @connector_config.api_key.value)
        }
      end,
      client_proc: proc {
        @confluence_client
      },
      config: ConnectorsSdk::Atlassian::Config.new(:base_url => @connector_config.base_url.to_s, :cursors => {}),
      features: {}
    )
  end

end
