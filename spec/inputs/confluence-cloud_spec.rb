# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/devutils/rspec/shared_examples"
require "logstash/inputs/confluence-cloud"

describe LogStash::Inputs::ConfluenceCloud do

  before(:each) do
    allow_any_instance_of(ConnectorsSdk::ConfluenceCloud::Extractor).to receive(:document_changes).and_return([])
  end

  it_behaves_like "an interruptible input plugin" do
    let(:config) { {
      "interval" => 100,
      'base_url' => 'http://workplace-search.atlassian.net',
      'username' => 'admin',
      'api_key' => '1234'
    } }
  end

end
