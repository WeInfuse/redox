# frozen_string_literal: true

module Redox
  module Models
    class Meta < Model
      TO_DATETIME_FORMAT   = '%Y-%m-%dT%H:%M:%S.%6NZ'
      FROM_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%N%Z'

      property :DataModel, from: :data_model, required: false
      property :EventType, from: :event_type, required: false
      property :EventDateTime, from: :event_date_time, default: -> { Time.now.utc.strftime(TO_DATETIME_FORMAT) }
      property :Test, from: :test, default: true
      property :Source, from: :source, required: false
      property :Destinations, from: :destinations, required: false
      property :FacilityCode, from: :facility_code, required: false

      alias data_model DataModel
      alias event_type EventType
      alias event_date_time EventDateTime
      alias test Test
      alias source Source
      alias destinations Destinations
      alias facility_code FacilityCode

      def add_destination(name:, id:)
        self[:Destinations] ||= []
        self[:Destinations] << Meta.build_subscription(name: name, id: id)

        self
      end

      def set_source(name:, id:)
        self[:Source] = Meta.build_subscription(name: name, id: id)

        self
      end

      class << self
        def build_subscription(name:, id:)
          {
            'ID' => id,
            'Name' => name
          }
        end
      end
    end
  end
end
