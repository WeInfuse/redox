module Redox
  module Request
    class Notes
      TRANSACTION_META = Redox::Models::Meta.new(EventType: 'New', DataModel: 'Notes')

      def self.create(notes, meta: Redox::Models::Meta.new)
        meta = NOTES_META.merge(meta)
        return Redox::Models::Model.from_response((RedoxClient.connection.request(body: Redox::Request.build_body(notes, meta))))
      end
    end
  end
end
