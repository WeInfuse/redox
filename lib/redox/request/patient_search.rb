module Redox
  module Request
    class PatientSearch
      QUERY_ENDPOINT = '/query'.freeze
      QUERY_META     = Redox::Models::Meta.new(EventType: 'Query', DataModel: 'PatientSearch')

      def self.query(params, meta: Redox::Models::Meta.new)
        meta = QUERY_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(endpoint: QUERY_ENDPOINT, body: Redox::Request::PatientAdmin.build_body(params, meta))))
      end
    end
  end
end
