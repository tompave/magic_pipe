module MagicPipe
  class TestRecord
    def initialize(id=1, foo="foo")
      @id = id
      @foo = foo
      @created_at = Time.now.utc
    end

    attr_reader :id, :foo, :created_at

    def self.find(id)
      new(id)
    end

    def as_json
      {
        "id" => id,
        "foo" => foo,
        "created_at" => created_at,
      }
    end

    def to_json
      JSON.dump(as_json)
    end

    def ==(other)
      self.to_json == other.to_json
    end
  end

  class TestRecordSerializer
    def initialize(record)
      @record = record
    end

    def as_json
      @record.as_json.merge({
        foofoo: (@record.foo * 2),
        FOO: @record.foo.upcase,
        age: (Time.now.utc.to_i - @record.created_at.to_i)
      }).map do |k, v|
        [k.to_sym, v]
      end.to_h
    end

    def to_json
      JSON.dump(as_json)
    end

    def ==(other)
      self.to_json == other.to_json
    end
  end
end
