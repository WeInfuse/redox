# frozen_string_literal: true

module Redox
  module Request
    class Financial
      TRANSACTION_META = Redox::Models::Meta.new(EventType: 'Transaction', DataModel: 'Financial')

      def self.create(financial, meta: Redox::Models::Meta.new)
        meta = TRANSACTION_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          financial, meta
        )))
      end
    end
  end
end
