module Redox
  module Models
    class AdvancedDirectives < Model
      property :Type, from: :type, required: false, default: {}
      property :Code, from: :code, required: false
      property :CodeSystem, from: :code_system, required: false
      property :CodeSystemName, from: :code_system_name, required: false
      property :Name, from: :name, required: false
      property :AltCodes, from: :alt_codes, required: false, default: []
      property :StartDate, from: :start_date, required: false
      property :EndDate, from: :end_date, required: false
      property :ExternalReference, from: :external_reference, required: false
      property :VerifiedBy, from: :verified_by, required: false, default: []
      property :Custodians, from: :custodians, required: false, default: []

      alias_method :advanced_directive_type, :Type
      alias_method :advanced_directive_code, :Code
      alias_method :advanced_directive_code_system, :CodeSystem
      alias_method :advanced_directive_code_system_name, :CodeSystemName
      alias_method :name, :Name
      alias_method :start_date, :StartDate
      alias_method :end_date, :EndDate
      alias_method :external_reference, :ExternalReference

    end
  end
end