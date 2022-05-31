#
# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.
#

# frozen_string_literal: true
require_relative 'base_config'

class FullConfig < BaseConfig

  def initialize(config_hash)
    super
  end

  def updates_since
    Time.at(0).strftime('%Y-%m-%dT%H:%M:%S.%L-%Z')
  end
end
