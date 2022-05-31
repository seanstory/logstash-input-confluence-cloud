#
# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.
#

# frozen_string_literal: true

require_relative '../../../lib/logstash/inputs/full_config'
require_relative '../../../lib/logstash/inputs/incremental_config'
require_relative '../../../lib/logstash/inputs/config_factory'
require 'active_support/core_ext/hash'


describe ConfigFactory do
  let(:base_config) do
    {
      :base_url => 'example.com',
      :username => 'admin',
      :api_key => '1234',
      :sync_type => 'full'
    }.with_indifferent_access
  end

  let(:incremental_config) do
    base_config.merge({:updates_since => '1991-11-21T00:00:00Z', :sync_type=> 'incremental' })
  end

  it 'creates the right config' do
    expect(ConfigFactory.get(base_config)).to be_instance_of(FullConfig)
    expect(ConfigFactory.get(incremental_config)).to be_instance_of(IncrementalConfig)
  end

end
