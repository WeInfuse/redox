module Redox
  module Models
    class Meta < Model
      KEY = 'Meta'.freeze

      DEFAULT = -> () {
        return {
          KEY => {
            'DataModel' => nil,
            'EventType' => nil,
            'EventDateTime' => Time.now.strftime("%Y-%m-%dT%H:%M:%S.%6NZ"),
            'Test' => true,
            'Source' => {},
            'Destinations' => [],
            'FacilityCode' => nil
          }
        }
      }

      def initialize(data = DEFAULT.call)
        super(data)
      end

      def add_destination(name, id)
        self.inner['Destinations'] << Meta.build_subscription(name, id)

        return self
      end

      def set_source(name, id)
        self.source = Meta.build_subscription(name, id)

        return self
      end

      def source=(source)
        self.inner['Source'] = source
      end

      def facility_code=(facility_code)
        self.inner['FacilityCode'] = facility_code.to_s
      end

      def test=(test)
        self.inner['Test'] = (true == test)
      end

      def merge(other)
        if (other.is_a?(Hash))
          if (other.include?(KEY))
            self.inner.merge!(other[KEY])
          else
            self.inner.merge!(other)
          end
        elsif (other.is_a?(self.class))
          self.inner.merge!(other.inner.select {|k,v| !v.nil?})
        end

        return self
      end

      def to_h
        return JSON.parse(@data.to_json)
      end

      class << self
        def build_subscription(name, id)
          return {
            'ID' => id,
            'Name' => name
          }
        end

        def from_h(hash)
          return Meta.new.merge(hash)
        end
      end
    end
  end
end
