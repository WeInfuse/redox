module Redox
  module Models
    class Media < AbstractModel
      property :FileType, from: :file_type, required: false
      property :FileName, from: :file_name, required: false
      property :FileContents, from: :file_contents, required: false
      property :DocumentType, from: :document_type, required: false
      property :DocumentID, from: :document_id, required: false
      property :Availability, from: :availability, required: false

      alias_method  :file_type, :FileType
      alias_method  :file_name, :FileName
      alias_method  :file_contents, :FileContents
      alias_method  :document_type, :DocumentType
      alias_method  :document_id, :DocumentID
      alias_method  :availability, :Availability
    end
  end
end
