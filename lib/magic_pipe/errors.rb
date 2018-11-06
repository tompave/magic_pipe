module MagicPipe
  class Error < StandardError
  end

  class ConfigurationError < Error
  end

  class LoaderError < Error
    def initialize(class_name, context)
      @message = "Can't resolve class name '#{class_name}' (#{context})"
    end
    attr_reader :message
  end

  module Transports
    class SubmitFailedError < MagicPipe::Error
      def initialize(transport_klass, message = nil)
        @message = "#{transport_klass} couldn't submit message (#{message})"
      end
      attr_reader :message
    end

    class NotImplementedError < SubmitFailedError
    end
  end
end
