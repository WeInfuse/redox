# frozen_string_literal: true

module Redox
  module Models
    class MediaUpload < AbstractModel
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Media, required: false, from: :media, default: Redox::Models::Media.new

      alias patient Patient
      alias visit Visit
      alias media Media
    end
  end
end
