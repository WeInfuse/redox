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

      def raw(key: self.class::KEY)
        if key.nil?
          return @data
        else
          return @data[key]
        end
      end

      def map(mapper: {}, data: self.raw)
        result = {}

        if (true == mapper.is_a?(Hash))
          mapper.each do |key, value|
            if (true == value.is_a?(Hash))
              result = result.merge(self.map(data: data[key], mapper: value))
            elsif (true == value.respond_to?(:call))
              lambda_result = value.call(data[key])

              if (true == lambda_result.is_a?(Hash))
                result = result.merge(lambda_result)
              else
                raise "lambda must return hash"
              end
            else
              result[value] = data[key]
            end
          end
        else
          raise "mapper must be a hash, got '#{mapper}'"
        end

        return result
      end
    end
  end
end
