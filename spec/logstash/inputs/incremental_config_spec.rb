#
# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.
#

# frozen_string_literal: true
require_relative '../../../lib/logstash/inputs/incremental_config'
require 'active_support/core_ext/hash'


describe IncrementalConfig do
  let(:expected_timestamp) { '1991-11-21T00:00:00Z' }
  let(:config_hash) do
    {
      :base_url => 'example.com',
      :username => 'admin',
      :api_key => '1234',
      :updates_since => expected_timestamp
    }.with_indifferent_access
  end
  subject { IncrementalConfig.new(config_hash) }
  it 'has the specified time' do
    expect(subject.updates_since).to eq(expected_timestamp)
  end
end
