# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/devutils/rspec/shared_examples"
require "logstash/inputs/confluence-cloud"

describe LogStash::Inputs::ConfluenceCloud do

  it_behaves_like "an interruptible input plugin" do
    let(:config) { {
      "interval" => 100,
      'base_url' => 'http://workplace-search.atlassian.net',
      'username' => 'admin',
      'password' => '1234'
    } }
  end

end
