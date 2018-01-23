module MagicPipe
  class Envelope
    def initialize(body:, topic:, producer:, time:, mime:)
      @body = body
      @topic = topic
      @producer = producer
      @time = time.to_i
      @mime = mime
    end


    def as_json(*)
      {
        body: @body.as_json,
        topic: @topic,
        producer: @producer,
        time: @time,
        mime: @mime,
      }
    end


    def ==(other)
      as_json == other.as_json
    end
  end
end
