Gem::Specification.new do |s|
  s.name          = 'logstash-input-confluence_cloud'
  s.version       = '0.1.0'
  s.licenses      = ['Elastic 2.0']
  s.summary       = 'Confluence Cloud Input'
  s.description   = 'A SpaceTime project to create a Connector-based logstash input plugin'
  s.homepage      = 'https://github.com/seanstory/logstash-input-confluence-cloud'
  s.authors       = ['Sean Story']
  s.email         = 'sean.j.story@gmail.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*', 'spec/**/*', 'vendor/**/*', '*.gemspec', '*.md', 'CONTRIBUTORS', 'Gemfile', 'LICENSE', 'NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'input' }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud', '>= 0.0.22'
  s.add_development_dependency 'logstash-devutils', '>= 0.0.16'
end
