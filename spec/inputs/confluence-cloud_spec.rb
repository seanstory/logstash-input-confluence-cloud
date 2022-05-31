# encoding: utf-8
require 'logstash/devutils/rspec/spec_helper'
require 'logstash/devutils/rspec/shared_examples'
require 'logstash/inputs/confluence-cloud'

describe LogStash::Inputs::ConfluenceCloud do
  let(:config) do
    {
      'connector_config' => {
        'base_url' => 'http://workplace-search.atlassian.net',
        'username' => 'admin',
        'api_key' => '1234',
        'sync_type' => 'full'
      }
    }
  end

  context 'with documents' do
    let(:queue) { SizedQueue.new(20) }
    subject { described_class.new(config) }
    let(:documents) do
      [
        {
          'foo' => 'bar',
          'baz' => 'qux'
        },
        {
          'floop' => 'doop',
          'scoop' => 'boop'
        }
      ]
    end

    before(:each) do
      subject.register
      allow_any_instance_of(ConnectorsSdk::ConfluenceCloud::Extractor).to receive(:document_changes)
          .and_yield(anything, documents[0], anything)
          .and_yield(anything, documents[1], anything)

    end

    it 'adds documents to the queue' do
      expect { subject.run(queue) }.to change { queue.size }.from(0).to(2)
      expect(queue.pop.to_hash.keys).to include('foo', 'baz')
      expect(queue.pop.to_hash.keys).to include('floop', 'scoop')
    end
  end

end
