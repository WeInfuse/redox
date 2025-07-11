# frozen_string_literal: true

module Redox
  module Models
    class Medications < AbstractModel
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :Administrations, required: false, from: :administrations, default: []

      alias patient Patient
      alias visit Visit
      alias administrations Administrations

      def create(meta: Meta.new)
        Redox::Request::Medications.administration(patient: self, meta: meta)
      end
    end
  end
end
