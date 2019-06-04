module Redox
  module Models
    class Patient < Model
      QUERY_ENDPOINT = '/query'.freeze
      QUERY_META     = Meta.new(EventType: 'Query', DataModel: 'PatientSearch')
      CREATE_META    = Meta.new(EventType: 'NewPatient', DataModel: 'PatientAdmin')
      UPDATE_META    = Meta.new(EventType: 'PatientUpdate', DataModel: 'PatientAdmin')

      property :Identifiers, from: :identifiers, required: false, default: []
      property :Insurances, from: :insurances, required: false, default: []
      property :Demographics, from: :demographics, required: false
      property :PCP, from: :primary_care_provider, required: false

      alias_method :identifiers, :Identifiers
      alias_method :insurances, :Insurances

      def demographics
        self[:Demographics] = Demographics.new(self[:Demographics]) unless self[:Demographics].is_a?(Redox::Models::Demographics)
        self[:Demographics] ||= Demographics.new
      end

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end

      def primary_care_provider
        self[:PCP] ||= PCP.new
      end

      def add_identifier(type: , value: )
        self[:Identifiers] << Identifier.new({'ID' => value, 'IDType' => type})

        return self
      end

      def add_insurance(data = {})
        self[:Insurances] << Insurance.new(data)

        return self
      end

      def update(meta: Meta.new)
        meta = UPDATE_META.merge(meta)
        return Model.from_response((RedoxClient.connection.request(body: Patient.body(self, meta))))
      end

      def create(meta: Meta.new)
        meta = CREATE_META.merge(meta)
        return Model.from_response((RedoxClient.connection.request(body: Patient.body(self, meta))))
      end

      class << self
        def query(params, meta: Meta.new)
          meta = QUERY_META.merge(meta)
          return Model.from_response((RedoxClient.connection.request(endpoint: QUERY_ENDPOINT, body: Patient.body(params, meta))))
        end

        def body(params, meta)
          meta = Meta.new.merge(meta)

          return meta.to_h.merge(params.to_h)
        end
      end
    end
  end
end
