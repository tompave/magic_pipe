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
          klass: @record.class,
          id: @record.id,
          wrapper: @wrapper,
        }
      end

      def self.load(record_klass, id, wrapper_klass=nil)
        record = record_klass.find(id)
        wrapper_klass ? wrapper_klass.new(record) : record
      end
    end
  end
end
