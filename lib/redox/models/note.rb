module Redox
  module Models
    class Note < AbstractModel
      property :ContentType, from: :content_type, required: false
      property :DocumentType, from: :document_type, required: false
      property :DocumentID, from: :document_id, required: false
      property :Provider, from: :provider, required: false
     
      alias_method :provider, :Provider
      alias_method :content_type, :ContentType
      alias_method :document_type, :DocumentType
      alias_method :document_id, :DocumentID

      def provider(id:)
         self[:Provider] = Redox::Models::NoteProvider.new(id: id)
      end
    end
  end
end
