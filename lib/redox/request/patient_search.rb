# frozen_string_literal: true

module Redox
  module Request
    class PatientSearch
      QUERY_ENDPOINT = '/query'
      QUERY_META     = Redox::Models::Meta.new(EventType: 'Query', DataModel: 'PatientSearch')

      def self.query(params, meta: Redox::Models::Meta.new)
        meta = QUERY_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(endpoint: QUERY_ENDPOINT,
                                                                          body: Redox::Request.build_body(
                                                                            params, meta
                                                                          )))
      end
    end
  end
end
