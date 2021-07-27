module Redox
  module Request
    class ClinicalSummary
      QUERY_ENDPOINT = '/query'.freeze
      QUERY_META     = Redox::Models::Meta.new(EventType: 'PatientQuery', DataModel: 'Clinical Summary')

      def self.query(params, meta: Redox::Models::Meta.new)
        meta = QUERY_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(endpoint: QUERY_ENDPOINT, body: Redox::Request.build_body(params, meta))))
      end
    end
  end
end
