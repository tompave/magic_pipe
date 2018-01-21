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

      :https_transport_options,
      # :sqs_transport_options,
      # :sidekiq_options,
    ]

    attr_accessor *FIELDS
    alias_method :transports=, :transport=
    alias_method :transports, :transport


    def initialize
      yield self if block_given?
      set_defaults
    end


    private


    def set_defaults
      @logger ||= Logger.new($stdout)
      @metrics_client ||= dummy_metrics_object

      @sender ||= :sync
      @codec ||= :yaml
      @transport ||= :log

      set_https_defaults
    end


    def set_https_defaults
      return unless @https_transport_options

      defaults = {
        url: "https://localhost:8080/foo",
        auth_token: "missing",
        timeout: 2,
        open_timeout: 3
      }
      @https_transport_options = defaults.merge(@https_transport_options)
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
