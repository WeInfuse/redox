# frozen_string_literal: true

module Redox
  module Request
    class Medications
      ADMINISTRATION_META = Redox::Models::Meta.new(EventType: 'Administration', DataModel: 'Medications')

      def self.administration(model, meta: Redox::Models::Meta.new)
        meta = ADMINISTRATION_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end
    end
  end
end
