# frozen_string_literal: true

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

      alias plan Plan
      alias member_number MemberNumber
      alias company Company
      alias group_number GroupNumber
      alias group_name GroupName
      alias effective_date EffectiveDate
      alias expiration_date ExpirationDate
      alias policy_number PolicyNumber
      alias agreement_type AgreementType
      alias coverage_type CoverageType
      alias insured Insured
    end
  end
end
