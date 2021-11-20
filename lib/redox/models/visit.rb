module Redox
  module Models
    class Visit < Model
      DEFAULT_LOCATION = {
        Department: nil,
        Facility: nil
      }
      DEFAULT_REFERRING_PROVIDER = {
        ID: nil,
        IDType: nil,
        FirstName: nil,
        LastName: nil
      }
      DEFAULT_ATTENDING_PROVIDER = {
        ID: nil,
        IDType: nil,
        FirstName: nil,
        LastName: nil
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
      property :CancelReason, from: :cancel_reason, required: false
      property :DischargeDateTime, from: :end, required: false
      property :ReferringProvider, from: :referring_provider, required: false, default: DEFAULT_REFERRING_PROVIDER
      property :AttendingProvider, from: :attending_provider, required: false, default: DEFAULT_ATTENDING_PROVIDER

      alias_method :insurances, :Insurances
      alias_method :start, :VisitDateTime
      alias_method :end, :DischargeDateTime
      alias_method :referring_provider, :ReferringProvider
      alias_method :attending_provider, :AttendingProvider

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

      def attending_provider_id=(v)
        self[:AttendingProvider] ||= DEFAULT_ATTENDING_PROVIDER
        self[:AttendingProvider][:ID] = v
      end

      def attending_provider_id_type=(v)
        self[:AttendingProvider] ||= DEFAULT_ATTENDING_PROVIDER
        self[:AttendingProvider][:IDType] = v
      end

      def attending_provider_first_name=(v)
        self[:AttendingProvider] ||= DEFAULT_ATTENDING_PROVIDER
        self[:AttendingProvider][:FirstName] = v
      end

      def attending_provider_last_name=(v)
        self[:AttendingProvider] ||= DEFAULT_ATTENDING_PROVIDER
        self[:AttendingProvider][:LastName] = v
      end

      def referring_provider_id=(v)
        self[:ReferringProvider] ||= DEFAULT_REFERRING_PROVIDER
        self[:ReferringProvider][:ID] = v
      end

      def referring_provider_id_type=(v)
        self[:ReferringProvider] ||= DEFAULT_REFERRING_PROVIDER
        self[:ReferringProvider][:IDType] = v
      end

      def referring_provider_first_name=(v)
        self[:ReferringProvider] ||= DEFAULT_REFERRING_PROVIDER
        self[:ReferringProvider][:FirstName] = v
      end

      def referring_provider_last_name=(v)
        self[:ReferringProvider] ||= DEFAULT_REFERRING_PROVIDER
        self[:ReferringProvider][:LastName] = v
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

        %w[VisitDateTime DischargeDateTime].each do |k|
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
