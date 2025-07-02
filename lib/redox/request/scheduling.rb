# frozen_string_literal: true

module Redox
  module Request
    class Scheduling
      CREATE_META       = Redox::Models::Meta.new(EventType: 'New', DataModel: 'Scheduling')
      CANCEL_META       = Redox::Models::Meta.new(EventType: 'Cancel', DataModel: 'Scheduling')
      RESCHEDULE_META   = Redox::Models::Meta.new(EventType: 'Reschedule', DataModel: 'Scheduling')
      MODIFICATION_META = Redox::Models::Meta.new(EventType: 'Modification', DataModel: 'Scheduling')

      def self.create(model, meta: Redox::Models::Meta.new)
        meta = CREATE_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end

      def self.cancel(model, meta: Redox::Models::Meta.new)
        meta = CANCEL_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end

      def self.reschedule(model, meta: Redox::Models::Meta.new)
        meta = RESCHEDULE_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end

      def self.modification(model, meta: Redox::Models::Meta.new)
        meta = MODIFICATION_META.merge(meta)
        Redox::Models::Model.from_response(RedoxClient.connection.request(body: Redox::Request.build_body(
          model, meta
        )))
      end
    end
  end
end
