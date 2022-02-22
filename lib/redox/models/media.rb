module Redox
  module Models
    class Media < AbstractModel
      BLOB_REQUIRED_SIZE = 200 * 1024

      property :FileType, from: :file_type, required: false
      property :FileName, from: :file_name, required: false
      property :FileContents, from: :file_contents, required: false
      property :DocumentType, from: :document_type, required: false
      property :DocumentID, from: :document_id, required: false
      property :Availability, from: :availability, required: false
      property :Provider, from: :provider, required: false
      property :DirectAddressFrom, from: :direct_address_from, required: false
      property :DirectAddressTo, from: :direct_address_to, required: false

      alias_method  :file_type, :FileType
      alias_method  :file_name, :FileName
      alias_method  :file_contents, :FileContents
      alias_method  :document_type, :DocumentType
      alias_method  :document_id, :DocumentID
      alias_method  :availability, :Availability
      alias_method  :provider, :Provider
      alias_method  :direct_address_from, :DirectAddressFrom
      alias_method  :direct_address_to, :DirectAddressTo

      def availability=(value)
        case value
        when true
          self[:Availability] = 'Available'
        when false
          self[:Availability] = 'Unavailable'
        else
          self[:Availability] = value
        end
      end

      def add_filepath(path)
        if File.size(path) > BLOB_REQUIRED_SIZE
          raise 'Not implemented'
        else
          self.file_contents = Base64::encode64(File.read(path))
          self.file_type     = "#{File.extname(path)}".delete_prefix('.').upcase
          self.file_name     = File.basename(path, '.*')
        end
      end
    end
  end
end
