require "magic_pipe/codecs/base"
require "yaml"

module MagicPipe
  module Codecs
    class Yaml < Base
      ENCODING = "yaml"

      def encode
        ::YAML.dump(o)
      end
    end
  end
end
