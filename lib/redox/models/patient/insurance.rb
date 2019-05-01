module Redox
  module Models
    class Insurance < Model
      property :Plan, required: false, from: :plan, default: {}
      property :MemberNumber, required: false, from: :member_number
      property :Company, required: false, from: :company, default: {}
      property :GroupNumber, required: false, from: :group_number
      property :GroupName, required: false, from: :group_name
      property :EffectiveDate, required: false, from: :effective_date
      property :ExpirationDate, required: false, from: :expiration_date
      property :PolicyNumber, required: false, from: :policy_number
      property :AgreementType, required: false, from: :agreement_type
      property :CoverageType, required: false, from: :coverage_type
      property :Insured, required: false, from: :insured, default: {}

      alias_method :plan, :Plan
      alias_method :member_number, :MemberNumber
      alias_method :company, :Company
      alias_method :group_number, :GroupNumber
      alias_method :group_name, :GroupName
      alias_method :effective_date, :EffectiveDate
      alias_method :expiration_date, :ExpirationDate
      alias_method :policy_number, :PolicyNumber
      alias_method :agreement_type, :AgreementType
      alias_method :coverage_type, :CoverageType
      alias_method :insured, :Insured
    end
  end
end
