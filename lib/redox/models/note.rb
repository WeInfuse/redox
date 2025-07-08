# frozen_string_literal: true

module Redox
  module Models
    class Note < AbstractModel
      property :ContentType, from: :content_type, required: false
      property :DocumentType, from: :document_type, required: false
      property :DocumentID, from: :document_id, required: false
      property :Provider, required: false, from: :provider, default: {}
      property :Components, required: false, from: :components, default: []

      alias content_type ContentType
      alias document_type DocumentType
      alias document_id DocumentID
      alias provider Provider
      alias components Components
    end
  end
end
