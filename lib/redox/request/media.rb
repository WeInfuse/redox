# frozen_string_literal: true

module Redox
  module Request
    class Media
      CREATE_META = Redox::Models::Meta.new(EventType: 'New', DataModel: 'Media')

      def self.create(model, meta: Redox::Models::Meta.new)
        meta = CREATE_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end
    end
  end
end
