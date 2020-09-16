module Redox
  module Request
    class PatientAdmin
      CREATE_META    = Redox::Models::Meta.new(EventType: 'NewPatient', DataModel: 'PatientAdmin')
      UPDATE_META    = Redox::Models::Meta.new(EventType: 'PatientUpdate', DataModel: 'PatientAdmin')

      def self.create(patient: , meta: Redox::Models::Meta.new)
        meta = CREATE_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(body: Redox::Request.build_body(patient, meta))))
      end

      def self.update(patient: , meta: Redox::Models::Meta.new)
        meta = UPDATE_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(body: Redox::Request.build_body(patient, meta))))
      end
    end
  end
end
