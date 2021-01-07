module Redox
  module Models
    class Visit < Model
      DEFAULT_LOCATION = {
        Department: nil,
        Facility: nil
      }

      property :Insurances, from: :insurances, required: false, default: []
      property :Location, from: :location, required: false, default: DEFAULT_LOCATION
      property :VisitDateTime, from: :start, required: false
      property :Duration, from: :duration, required: false
      property :VisitNumber, from: :visit_number, required: false
      property :AccountNumber, from: :account_number, required: false
      property :Status, from: :status, required: false
      property :Type, from: :type, required: false
      property :Reason, from: :reason, required: false
      property :Equipment, from: :equipment, required: false

      alias_method :insurances, :Insurances
      alias_method :start, :VisitDateTime

      def department=(v)
        self[:Location] ||= DEFAULT_LOCATION
        self[:Location][:Department] = v
        self
      end

      def facility=(v)
        self[:Location] ||= DEFAULT_LOCATION
        self[:Location][:Facility] = v
        self
      end

      def add_equipment(description: nil, code: nil)
        self[:Equipment] ||= []
        self[:Equipment] << { Description: description, Code: code }
        self
      end

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end

      def to_h
        result = super.to_h

        %w[VisitDateTime].each do |k|
          result[key][k] = Redox::Models.format_datetime(result[key][k])
        end

        result
      end

      def to_json(args = {})
        self.to_h.to_json
      end

      def as_json(args = {})
        self.to_h.dig('Visit')
      end
    end
  end
end
