module Redox
  module Models
    class Note < AbstractModel
      property :ContentType, from: :content_type, required: false
      property :DocumentType, from: :document_type, required: false
      property :DocumentID, from: :document_id, required: false
      property :Provider, required: false, from: :provider, default: {}
      property :Components, required: false, from: :components, default: []

      alias_method :content_type, :ContentType
      alias_method :document_type, :DocumentType
      alias_method :document_id, :DocumentID
      alias_method :provider, :Provider
      alias_method :components, :Components
    end
  end
end
