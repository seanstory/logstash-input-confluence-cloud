# encoding: utf-8
require 'logstash/inputs/base'
require 'stud/interval'
require 'socket' # for Socket.gethostname
require 'connectors_sdk'

# Generate a repeating message.
#
# This plugin is intented only as an example.

class LogStash::Inputs::ConfluenceCloud < LogStash::Inputs::Base
  config_name 'confluence-cloud'

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, 'plain'

  # Set how frequently messages should be sent.
  #
  # The default, `1`, means send a message every second.
  config :interval, :validate => :number, :default => 1

  config :base_url, :validate => :uri, :required => true
  config :username, :validate => :string, :required => true
  config :api_key, :validate => :password, :required => true

  public
  def register
    @host = Socket.gethostname
    @confluence_client = ConnectorsSdk::ConfluenceCloud::CustomClient.new(
      :base_url => @base_url.to_s,
      :access_token => nil,
      :basic_auth_token => basic_auth_token(@username, @api_key.value)
    )
    @extractor = ConnectorsSdk::ConfluenceCloud::Extractor.new(
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
  end # def register

  def run(queue)
    Time.zone_default = Time.find_zone!('Eastern Time (US & Canada)')
    while !stop?
      @extractor.document_changes do |action, document_or_es_id, download_metadata|
        if stop?
          break
        end
        event = LogStash::Event.new(document_or_es_id)
        decorate(event)
        queue << event
      end
      Stud.stoppable_sleep(@interval) { stop? }
    end
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end

  private

  def basic_auth_token(username, password)
    Base64.encode64("#{username}:#{password}").gsub(/\s/,'')
  end

end # class LogStash::Inputs::ConfluenceCloud
