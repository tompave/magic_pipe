require "magic_pipe/codecs/base"

module MagicPipe
  module Codecs
    class Json < Base
      ENCODING = "json"

      def encode
        if o.respond_to?(:to_json)
          o.to_json
        elsif o.respond_to?(:as_json)
          json_dump(o.as_json)
        else
          json_dump(o)
        end
      end


      private


      begin
        require "oj"

        def json_dump(data)
          Oj.dump(data)
        end
      rescue LoadError
        puts "[#{self.to_s}] The oj gem is not available. Using json from the stdlib."
        require "json"

        def json_dump(data)
          JSON.dump(data)
        end
      end
    end
  end
end
