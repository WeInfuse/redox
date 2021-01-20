module Redox
  module Models
    class MediaUpload < AbstractModel
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Media, required: false, from: :media, default: Redox::Models::Media.new

      alias_method :patient, :Patient
      alias_method :visit, :Visit
      alias_method :media, :Media
    end
  end
end
