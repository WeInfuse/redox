module Redox
  module Models
    class Note < AbstractModel
      property :ContentType, from: :content_type, required: true
      property :DocumentType, from: :document_type, required: true
      property :DocumentID, from: :document_id, required: true
      property :Provider, from: :provider, required: true
     
      alias_method :provider, :Provider

      def provider(id:)
         self[:Provider] = Redox::Models::NoteProvider.new(id: id)
      end
    end
  end
end
