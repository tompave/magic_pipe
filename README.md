# MagicPipe

[![Build Status](https://travis-ci.org/tompave/magic_pipe.svg?branch=master)](https://travis-ci.org/tompave/magic_pipe)

MagicPipe is a Ruby library to push data to remote destinations on multiple topics.

It provides client adapters for several popular message busses, and it's meant to facilitate publishing messages and streaming data, in different formats and to different backends.

## Content

* [Design, concepts and internals](#design-concepts-and-internals)
  - [The moving parts](#the-moving-parts)
    + [Codecs](#codecs)
    + [Transports](#transports)
    + [Senders](#senders)
    + [Loaders](#loaders)
  - [Gluing everything together](#gluing-everything-together)
  - [Multiple pipes](#multiple-pipes)
  - [The message payloads](#the-message-payloads)
* [Usage](#usage)
  - [Configuration](#configuration)
* [Dependencies](#dependencies)
* [Use cases](#use-cases)
* [Installation](#installation)

## Design, concepts and internals

Its design principles are:

* It should be plug and play, with minimal configuration -- it's an opinionated library.
* It should support different message formats and backends with a consistent interface.
* It should allow for multiple backends to be targeted at the same time.
* It should be extendable and customizable.

To achieve these goals, MagicPipe adopts a modular design with interchangeable parts.

### The moving parts

The four main units of work are codecs, transports, senders and loaders. MagicPipe provides a set of classes out of the box, but users of the library can configure their own custom classes that implement the correct interface.

#### Codecs

Codecs accept a Ruby object and produce an encoded output. The input must respond to `as_json` and return a Hash. The provided codecs are:

* Yaml
* JSON
* MessagePack
* Thrift (work in progress)

#### Transports

Transports are adapters for the different backends, and take care of establishing connections and submitting the payloads. The provided transports are:

* Debug
* Log
* HTTPS
* SQS
* Kafka (work in progress)
* DynamoDB (work in progress)
* Multi (allows to target different transports at the same time)

#### Senders

Senders glue things together and implement a processing strategy. The provided senders are:

* Sync
* Async (Sidekiq)

#### Loaders

Loaders are used with the Async sender to serialize Ruby objects into something that can be passed to Sidekiq, and then to rebuild the original Objects inside the Sidekiq workers. The provided loaders are:

* SimpleActiveRecord: it takes `ActiveRecord::Base` instances and an optional wrapper (e.g. an `ActiveModel::Serializer`) and turns them into class references (Strings) and a record ID. Then, when the Sidekiq jobs execute, it loads the record from the DB and wraps it in the serializer, if present.

### Gluing everything together

A MagicPipe client encapsulates the configured parts. For example, clients with a single and multiple transports can be represented like this:

```
Client
├ Configuration
└ Sender
  ├ Codec
  ├ (Loader)
  └ Transport

Client
├ Configuration
└ Sender
  ├ Codec
  ├ (Loader)
  └ Transports
    ├ Transport A
    ├ Transport B
    └ Transport C
```

A client can only have a single codec and sender, but can have multiple transports to submit data to multiple backends. This is particularly efficient because it allows to reduce the number of DB queries to re-load the data, when using the async sender.

### Multiple pipes

Multiple clients with different configurations can be used together in the same process.

The main use case is to support different codecs (message formats). Some applications may in fact need to emit messages with different formats to different backends, for example JSON to both SQS and a remote HTTPS endpoint, and Thrift to Kafka.

Another use case is to use different Sidekiq queues (and worker pools) for different topics, which can be accomplished by using different MagicPipe clients for different types of objects.

### The message payloads

MagicPipe wraps the payloads in message envelopes with extra metadata. These extra attributes are:

* the message topic (string)
* the producer name (string)
* the submission timestamp, captured when `client#send_data` is invoked (integer)
* the payload mime type, e.g. `application/json` (string)

Some transports will additionally provide this metadata as message meta attributes. For example, the HTTPS transport will set them as custom HTTP request headers, and the SQS transport will set them as the SQS message custom attributes.

## Usage

Create and configure a MagicPipe client:
(Temporary API! Still a work in progress)

```ruby
require "magic_pipe/senders/async"
require "magic_pipe/transports/https"
require "magic_pipe/transports/sqs"

$magic_pipe = MagicPipe.build do |mp|
  mp.sender = :async
  mp.loader = :simple_active_record

  mp.codec = :json
  mp.transports = [:https, :sqs]

  mp.sidekiq_options = {
    queue: "magic_pipe"
  }
  mp.https_transport_options = {
    url: "https://my.receiver.service/foo",
    auth_token: "bar",
  }
  mp.sqs_transport_options = {
    queue: "my_data_stream"
  }

  mp.logger = Rails.logger
  mp.metrics_client = $statsd_client
end
```

Then, to submit a message:

```ruby
$magic_pipe.send_data(
  object: object,
  topic: "my_topic",
  wrapper: nil, # default
  time: Time.now.utc # default
)
```

A more concrete example, with an active record object:

```ruby
class Article < ActiveRecord::Base
  after_commit :send_on_magic_pipe

  private

  def send_on_magic_pipe
    $magic_pipe.send_data(
      object: self,
      topic: "articles",
      wrapper: Serializers::InventoryArticleSerializer,
      time: updated_at
    )
  end
end
```

### Configuration

#### Transport: SQS

This transport requires credentials for the AWS API. The credentials need to be associated to an IAM user with full access to SQS, and need to be present in the system env:

```
export AWS_ACCESS_KEY_ID='foo'
export AWS_SECRET_ACCESS_KEY='bar'
export AWS_REGION='us-east-1'
```

## Dependencies

Becasuse of MagicPipe's modular design, and in order to keep a small installation footprint, all of its dependencies are optional. Users of the library need to manually install the required dependencies in their projects.

The Ruby gems MagicPipe's modules depend on are:

* Senders:
  - Async: `sidekiq`
* Transports:
  - SQS: `aws-sdk-sqs`
  - HTTPS: `faraday`, `typhoeus`
* Codecs:
  - JSON: `oj` (optional, will fallback to `json` from the stdlib if `oj` is missing)
  - MessagePack: `msgpack`

## Use cases

TODO

* event driven architectures
* streaming domain data to replicate it somewhere else

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic_pipe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magic_pipe
