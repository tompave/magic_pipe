module MagicPipe
  class Envelope
    def initialize(body:, topic:, producer:, time:)
      @body = body
      @topic = topic
      @producer = producer
      @time = time.to_i
    end


    def as_json(*)
      {
        topic: @topic,
        producer: @producer,
        time: @time,
        body: @body.as_json
      }
    end


    def ==(other)
      as_json == other.as_json
    end
  end
end
