# encoding: utf-8
require 'logstash/inputs/base'
require 'stud/interval'
require 'connectors_sdk'


class LogStash::Inputs::ConfluenceCloud < LogStash::Inputs::Base
  config_name 'confluence-cloud'

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, 'plain'

  # Set the url (including "/wiki/") of the Confluence Cloud account
  config :base_url, :validate => :uri, :required => true

  # Set the username of the Confluence Cloud user to authenticate as
  config :username, :validate => :string, :required => true

  # Set the API Key for the Confluence Cloud user to authenticate with
  config :api_key, :validate => :password, :required => true

  public
  def register
    @confluence_client = ConnectorsSdk::ConfluenceCloud::CustomClient.new(
      :base_url => @base_url.to_s,
      :access_token => nil,
      :basic_auth_token => basic_auth_token(@username, @api_key.value)
    )
  end # def register

  def run(queue)
    Time.zone_default = Time.find_zone!('UTC')
    extractor.document_changes do |_a, document_or_es_id, _b|
      if stop?
        break
      end
      event = LogStash::Event.new(document_or_es_id)
      decorate(event)
      queue << event
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
          :base_url => @base_url.to_s,
          :access_token => nil,
          :basic_auth_token => basic_auth_token(@username, @api_key.value)
        }
      end,
      client_proc: proc {
        @confluence_client
      },
      config: ConnectorsSdk::Atlassian::Config.new(:base_url => @base_url.to_s, :cursors => {}),
      features: {}
    )
  end

end
