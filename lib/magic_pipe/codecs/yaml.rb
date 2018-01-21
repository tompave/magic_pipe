require "magic_pipe/codecs/base"
require "yaml"

module MagicPipe
  module Codecs
    class Yaml < Base
      # text/vnd.yaml
      # text/x-yaml
      # application/x-yaml

      TYPE = "application/x-yaml"

      def encode
        ::YAML.dump(o)
      end
    end
  end
end
