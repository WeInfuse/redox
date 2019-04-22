module Redox
  module Models
    class Patient < Model
      attr_reader :demographics, :identifiers

      KEY = 'Patient'.freeze

      SEARCH = {
        meta: {
          'DataModel' => 'PatientSearch',
          'EventType' => 'Query'
        },
        endpoint: '/query'
      }

      ADD = {
        meta: {
          'DataModel' => 'PatientAdmin',
          'EventType' => 'NewPatient'
        },
        endpoint: '/endpoint'
      }

      UPDATE = {
        meta: {
          'DataModel' => 'PatientAdmin',
          'EventType' => 'PatientUpdate'
        },
        endpoint: '/endpoint'
      }

      def initialize(data)
        super(data)

        if (self.valid?)
          @demographics = Demographics.new(self.inner)
          @identifiers  = Identifiers.new(self.inner)
        end
      end
    end
  end
end
