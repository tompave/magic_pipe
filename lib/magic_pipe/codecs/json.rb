require "json"
require "magic_pipe/codecs/base"

module MagicPipe
  module Codecs
    class Json < Base
      def encode
        if o.respond_to?(:to_json)
          o.to_json
        elsif o.respond_to?(:as_json)
          JSON.dump(o.as_json)
        else
          JSON.dump(o)
        end
      end

      def encoding
        :json
      end
    end
  end
end
