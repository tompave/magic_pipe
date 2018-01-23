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
        def load(record_klass_name, record_id, wrapper_klass_name=nil)
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
      end
    end
  end
end
