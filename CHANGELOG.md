# MagicPipe Changelog

## v0.4.1 (unreleased)

When the `Https` adapter raises a delivery error, also report info about the HTTP failure.

## v0.4.0

Bug fix: Ensure that the `Https` transport raises an exception when the HTTP POST request fails.

## v0.3.0

* Allow to set the `basic_auth` config as a proc which gets the topic name passed. (thanks @Crunch09, https://github.com/tompave/magic_pipe/pull/1)

Example:

```ruby
basic_auth: ->(topic) {
    username = ENV["TOPIC_#{topic.singularize.upcase}_USER"]
    password = ENV["SECRET_PASSWORD"]
    "#{username}:#{password}"
}
```

It should always return a string in the format `USERNAME:PASSWORD`. Instead
of using a proc this string can be set directly:

```ruby
basic_auth: "foo:bar"
```

In favor of this `basic_auth_user` and `basic_auth_password` have been removed.

## v0.2.0

Enhancing the HTTPS transport:

* Allow to configure both user and password for HTTP Basic Auth.
* Allow to configure a callable to use dynamic URL paths.

## v0.1.0

Initial release.

Codecs: json, message_pack, jaml.
Loaders: simple_active_record.
Senders: sync and async (Sidekiq).
Transports: debug, log, https, sqs, multi.
