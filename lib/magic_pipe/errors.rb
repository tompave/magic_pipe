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
end
