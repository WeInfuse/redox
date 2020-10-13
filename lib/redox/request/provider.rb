module Redox
  module Request
    class Provider
      QUERY_META = Redox::Models::Meta.new(EventType: 'ProviderQuery', DataModel: 'Provider')

      def self.query(provider, meta: Redox::Models::Meta.new)
        meta = QUERY_META.merge(meta)
        return Redox::Models::Model.from_response_inflected((RedoxClient.connection.request(body: Redox::Request.build_body(provider, meta))))
      end
    end
  end
end
