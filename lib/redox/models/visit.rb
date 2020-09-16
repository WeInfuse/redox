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
      property :VisitNumber, from: :visit_number, required: false
      property :AccountNumber, from: :account_number, required: false

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

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end

      def to_json(args = nil)
        d = self.dup
        d[:VisitDateTime] = Redox::Models.format_datetime(d[:VisitDateTime])
        d.to_h.to_json
      end
    end
  end
end
