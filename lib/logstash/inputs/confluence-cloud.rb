# encoding: utf-8
require "logstash/inputs/base"
require "stud/interval"
require "socket" # for Socket.gethostname
require "connectors_sdk"

# Generate a repeating message.
#
# This plugin is intented only as an example.

class LogStash::Inputs::ConfluenceCloud < LogStash::Inputs::Base
  config_name "confluence-cloud"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "plain"

  # Set how frequently messages should be sent.
  #
  # The default, `1`, means send a message every second.
  config :interval, :validate => :number, :default => 1

  config :base_url, :validate => :uri, :required => true
  config :username, :validate => :string, :required => true
  config :password, :validate => :password, :required => true

  public
  def register
    @host = Socket.gethostname
    @confluence_client = ConnectorsSdk::ConfluenceCloud::CustomClient.new(
      :base_url => @base_url.to_s,
      :access_token => nil,
      :basic_auth_token => basic_auth_token(@username, @password.value)
    )
  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    while !stop?
      event = LogStash::Event.new("message" => @confluence_client.me.to_s, "host" => @host)
      decorate(event)
      queue << event
      # because the sleep interval can be big, when shutdown happens
      # we want to be able to abort the sleep
      # Stud.stoppable_sleep will frequently evaluate the given block
      # and abort the sleep(@interval) if the return value is true
      Stud.stoppable_sleep(@interval) { stop? }
    end # loop
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
    Base64.encode64("#{username}:#{password}")
  end

end # class LogStash::Inputs::ConfluenceCloud
