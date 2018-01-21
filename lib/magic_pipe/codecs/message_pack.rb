require "magic_pipe/codecs/base"

begin
  require "msgpack"

  module MagicPipe
    module Codecs
      class MessagePack < Base
        TYPE = "application/x-msgpack"

        def encode
          case o
          when Hash
            o.to_msgpack
          else
            o.as_json.to_msgpack
          end
        end
      end
    end
  end

  # Extensions required to serialize time values

  begin
    # If used in Rails, most timestamps will be
    # ActiveSupport::TimeWithZone instances.

    require "active_support/time_with_zone"

    ActiveSupport::TimeWithZone.class_eval do
      def to_msgpack_ext
        ("TWZ[" + self.to_s + "]").to_msgpack
      end

      def self.from_msgpack_ext(data)
        Time.zone.parse(data)
      end
    end
    MessagePack::DefaultFactory.register_type 0x42, ActiveSupport::TimeWithZone
  rescue LoadError
  end

  require "time"
  require "date"

  Time.class_eval do
    def to_msgpack_ext
      to_i.to_msgpack
    end

    def self.from_msgpack_ext(data)
      n = MessagePack.unpack(data)
      Time.at(n)
    end
  end
  MessagePack::DefaultFactory.register_type 0x43, Time

  Date.class_eval do
    def to_msgpack_ext
      ("D[" + to_s + "]").to_msgpack
    end

    def self.from_msgpack_ext(data)
      Date.parse(MessagePack.unpack(data))
    end
  end
  MessagePack::DefaultFactory.register_type 0x44, Date

  DateTime.class_eval do
    def to_msgpack_ext
      ("DT[" + to_s + "]").to_msgpack
    end

    def self.from_msgpack_ext(data)
      DateTime.parse(MessagePack.unpack(data))
    end
  end
  MessagePack::DefaultFactory.register_type 0x45, DateTime
rescue LoadError
end
