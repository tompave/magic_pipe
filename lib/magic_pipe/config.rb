require "logger"
require "singleton"

module MagicPipe
  class Config
    FIELDS = [
      :logger,           # A Logger
      :metrics_client,   # Statsd compatible object
      :codec,
      :transport,
      :sender,
    ]

    attr_accessor *FIELDS


    def initialize
      yield self if block_given?
      set_defaults
    end


    private


    def set_defaults
      @logger ||= Logger.new($stdout)
      @metrics_client ||= dummy_metrics_object
    end


    def dummy_metrics_object
      Class.new do
        def initialize(logger)
          @out = logger
        end
        def method_missing(name, *args, &block)
          @out.debug("[metrics] #{name}: #{args}")
          # Uncomment this to create a black hole
          # self.class.new(@out)
        end
        def respond_to_missing?(*)
          true
        end
      end.new(@logger)
    end
  end
end
