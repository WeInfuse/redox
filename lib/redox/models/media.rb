# frozen_string_literal: true

module Redox
  module Models
    class Media < AbstractModel
      BLOB_REQUIRED_SIZE = 200 * 1024

      property :Availability, from: :availability, required: false
      property :DirectAddressFrom, from: :direct_address_from, required: false
      property :DirectAddressTo, from: :direct_address_to, required: false
      property :DocumentID, from: :document_id, required: false
      property :DocumentType, from: :document_type, required: false
      property :FileContents, from: :file_contents, required: false
      property :FileName, from: :file_name, required: false
      property :FileType, from: :file_type, required: false
      property :Notifications, from: :notifications, required: false, default: []
      property :Provider, from: :provider, required: false
      property :ServiceDateTime, from: :service_date_time, required: false

      alias availability Availability
      alias direct_address_from DirectAddressFrom
      alias direct_address_to DirectAddressTo
      alias document_id DocumentID
      alias document_type DocumentType
      alias file_contents FileContents
      alias file_name FileName
      alias file_type FileType
      alias provider Provider
      alias service_date_time ServiceDateTime
      alias notifications Notifications

      def availability=(value)
        self[:Availability] = case value
                              when true
                                'Available'
                              when false
                                'Unavailable'
                              else
                                value
                              end
      end

      def add_filepath(path)
        raise 'Not implemented' if File.size(path) > BLOB_REQUIRED_SIZE

        self.file_contents = Base64.encode64(File.read(path))
        self.file_type     = File.extname(path).to_s.delete_prefix('.').upcase
        self.file_name     = File.basename(path, '.*')
      end
    end
  end
end
