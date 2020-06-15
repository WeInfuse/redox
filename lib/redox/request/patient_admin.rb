module Redox
  module Request
    class PatientAdmin
      CREATE_META    = Redox::Models::Meta.new(EventType: 'NewPatient', DataModel: 'PatientAdmin')
      UPDATE_META    = Redox::Models::Meta.new(EventType: 'PatientUpdate', DataModel: 'PatientAdmin')

      def self.create(patient: p, meta: Redox::Models::Meta.new)
        meta = CREATE_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(body: Redox::Request::PatientAdmin.build_body(p, meta))))
      end

      def self.update(patient: p, meta: Redox::Models::Meta.new)
        meta = UPDATE_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(body: Redox::Request::PatientAdmin.build_body(p, meta))))
      end

      def self.build_body(params, meta)
        meta = Redox::Models::Meta.new.merge(meta)

        return meta.to_h.merge(params.to_h)
      end
    end
  end
end
