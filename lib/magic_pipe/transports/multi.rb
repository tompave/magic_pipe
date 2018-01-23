require "magic_pipe/transports/base"

module MagicPipe
  module Transports
    class Multi < Base
      def initialize(config, metrics)
        super(config, metrics)
        @transports = build_nested_transports
      end


      def submit(payload, metadata)
        @transports.map do |transport|
          begin
            transport.submit(payload, metadata)
          rescue => e
            log_error(e, transport)
          end
        end
      end


      private


      def build_nested_transports
        @config.transport.map do |transport|
          klass = MagicPipe::Transports.lookup(transport)
          klass.new(@config, @metrics)
        end
      end


      def log_error(e, transport)
        @logger.error(
          "[MagicPipe] Transports::Multi, error submitting with %{t} (%{e})." % {
            t: transport.class,
            e: e
          }
        )
      end
    end
  end
end
