module Redox
  module Models
    class Patient < Model
      attr_reader :demographics, :identifiers

      KEY = 'Patient'

      SEARCH = {
        meta: {
          data_model: 'PatientSearch',
          event_type: 'Query'
        },
        endpoint: '/query'
      }

      def initialize(data)
        super(data)

        if (self.valid?)
          @demographics = Demographics.new(self.raw)
          @identifiers  = Identifiers.new(self.raw)
        end
      end
    end
  end
end
