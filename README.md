# MagicPipe

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/magic_pipe`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic_pipe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magic_pipe

## Usage

```ruby
client = MagicPipe.build do |mp|
  mp.codec = :json
  mp.sender = :async
  mp.transport = :https

  mp.sidekiq_options = {}
  mp.https_transport_options = {
    url: "https://something.dev/foo",
    auth_token: "bar",
    timeout: 1,
    open_timeout: 1
  }
  mp.sqs_transport_options = {
    aws_access_key_id: ENV["A"],
    aws_secret_access_key: ENV["B"],
    queue_name: "foooo"
  }

  mp.logger = Rails.logger
  mp.metrics_client = STATSD_CLIENT
end

client.send_data(object)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/magic_pipe.
