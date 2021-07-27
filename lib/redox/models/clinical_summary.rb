module Redox
  module Models
    class ClinicalSummary < Model
      property :Header, from: :header, required: false
      property :AdvancedDirectives, from: :advanced_directives, required: false, default: []
      property :Allergies, from: :allergies, required: false, default: []
      property :Encounters, from: :encounters, required: false, default: []
      property :FamilyHistory, from: :family_history, required: false, default: []
      property :Immunizations, from: :immunizations, required: false, default: []
      property :Insurances, from: :insurances, required: false, default: []
      property :MedicalEquipment, from: :medical_equipment, required: false, default: []
      property :Medications, from: :medications, required: false, default: []
      property :Patient, from: :patient, required: false
      property :PlanOfCare, from: :plan_of_care, required: false
      property :Problems, from: :problems, required: false, default: []
      property :Procedures, from: :procedures, required: false, default: []
      property :Results, from: :results, required: false, default: []
      property :SocialHistory, from: :social_history, required: false
      property :VitalSigns, from: :vital_signs, required: false, default: []

      alias_method :advanced_directives, :AdvancedDirectives
      alias_method :insurances, :Insurances
      alias_method :patient, :Patient
      alias_method :vital_signs, :VitalSigns

      def advanced_directives
        self[:AdvancedDirectives] = self[:AdvancedDirectives].map {|ad| ad.is_a?(Redox::Models::AdvancedDirectives) ? ad : AdvancedDirectives.new(ad)}
      end

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end

      def patient
        self[:Patient] = Patient.new(self[:Patient]) unless self[:Patient].is_a?(Redox::Models::Patient)
        self[:Patient] ||= Patient.new
      end

      def insurances
        self[:VitalSigns] = self[:VitalSigns].map {|vs| vs.is_a?(Redox::Models::VitalSigns) ? vs : VitalSigns.new(vs) }
      end

      class << self
        def query(params, meta: Meta.new)
          params = {"Patient" => {"Identifiers" => params.patient.identifiers.map {|i| i.to_h}}}

          return Redox::Request::ClinicalSummary.query(params, meta: meta)
        end
      end
    end
  end
end