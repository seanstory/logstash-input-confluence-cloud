# Confluence Cloud Logstash Input Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open code. The license is Elastic 2.0, meaning you are pretty much free to use it however you want in whatever way, as long as you don't sell it as a SaaS offering.

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need rbenv and JRuby with the Bundler gem installed.

- Next, clone [Logstash](https://github.com/elastic/logstash), and set the following environment variables:
```sh
export LOGSTASH_PATH=/path/to/cloned/logstash
export LOGSTASH_SOURCE=1
```

- Install dependencies
```sh
bundle install
```

#### Test

- Run tests

```sh
bundle exec rspec
```

### 2. Running this unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-input-confluence-cloud", :path => "/your/local/logstash-input-confluence-cloud"
```
- Install plugin
```sh
bin/logstash-plugin install --no-verify
```
- Run Logstash with your plugin
```sh
bin/logstash -e '
input { 
    confluence-cloud { 
        username => "YOUR_USERNAME_HERE" 
        api_key => "YOUR_API_KEY_HERE" 
        base_url => "https://YOUR_SITE_HERE.atlassian.net/wiki"
    }
} 
output { 
    stdout {} 
}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-awesome.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/logstash-plugin install /your/local/plugin/logstash-filter-awesome.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/main/CONTRIBUTING.md) file.
