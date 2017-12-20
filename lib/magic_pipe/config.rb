require "logger"
require "singleton"

module MagicPipe

  def self.config
    yield Config.instance if block_given?
    Config.instance
  end


  class Config
    include Singleton

    FIELDS = [
      :logger,           # A Logger
      :metrics_client,   # Statsd compatible object
    ]

    attr_accessor *FIELDS


    # Configuration defaults
    #
    def initialize
      @logger = Logger.new($stdout)

      @metrics_client = Class.new do
        def method_missing(*)
          self.class.new
        end
        def respond_to_missing?(*)
          true
        end
      end.new # a black hole
    end
  end
end
