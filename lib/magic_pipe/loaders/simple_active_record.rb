module MagicPipe
  module Loaders
    class SimpleActiveRecord
      def initialize(record, wrapper=nil)
        @record = record
        @wrapper = wrapper
      end

      attr_reader :record

      def decompose
        {
          klass: @record.class.to_s,
          id: @record.id,
          wrapper: (@wrapper && @wrapper.to_s),
        }
      end


      class << self
        def load(decomposed_data)
          input = symbolize_keys(decomposed_data)
          record_klass_name = input[:klass]
          record_id = input[:id]
          wrapper_klass_name = input[:wrapper]

          record_klass = load_constant!(record_klass_name, "ActiveRecord model")
          record = record_klass.find(record_id) # let it raise ActiveRecord::RecordNotFound

          if wrapper_klass_name
            wrapper_klass = load_constant!(wrapper_klass_name, "object serializer")
            wrapper_klass.new(record)
          else
            record
          end
        end

        private

        def load_constant!(name, context)
          Object.const_get(name)
        rescue NameError
          raise MagicPipe::LoaderError.new(name, context)
        end

        def symbolize_keys(hash)
          hash.map do |k, v|
            [k.to_sym, v]
          end.to_h
        end
      end
    end
  end
end
