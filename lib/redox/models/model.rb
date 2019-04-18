module Redox
  module Models
    class Model
      KEY = nil

      def initialize(data)
        @data = data.freeze
      end

      def valid?
        return @data.is_a?(Hash) && @data.include?(self.class::KEY)
      end

      def raw
        return self.inner(key: nil)
      end

      def inner(key: self.class::KEY)
        if key.nil?
          return @data
        else
          return @data[key]
        end
      end
    end
  end
end
