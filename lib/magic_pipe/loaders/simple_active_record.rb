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

      def self.load(record_klass_s, id, wrapper_klass_n=nil)
        record_klass = Object.const_get(record_klass_s)
        record = record_klass.find(id)

        if wrapper_klass_n
          wrapper_klass = Object.const_get(wrapper_klass_n)
          wrapper_klass.new(record)
        else
          record
        end
      end
    end
  end
end
