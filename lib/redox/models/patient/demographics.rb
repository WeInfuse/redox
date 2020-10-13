module Redox
  module Models
    class Demographics < AbstractModel
      property :FirstName, required: false, from: :first_name
      property :MiddleName, required: false, from: :middle_name
      property :LastName, required: false, from: :last_name
      property :DOB, required: false, from: :dob
      property :SSN, required: false, from: :ssn
      property :Sex, required: false, from: :sex
      property :Race, required: false, from: :race
      property :IsHispanic, required: false
      property :MaritalStatus, required: false, from: :martial_status
      property :IsDeceased, required: false
      property :DeathDateTime, required: false
      property :Language, required: false, from: :language
      property :EmailAddresses, required: false, default: []
      property :Citizenship, required: false, default: []
      property :Address, required: false, default: {}
      property :PhoneNumber, required: false, default: {}

      alias_method :first_name, :FirstName
      alias_method :middle_name, :MiddleName
      alias_method :last_name, :LastName
      alias_method :dob, :DOB
      alias_method :ssn, :SSN
      alias_method :sex, :Sex
      alias_method :race, :Race
      alias_method :martial_status, :MaritalStatus
      alias_method :language, :Language
      alias_method :address, :Address
      alias_method :phone_number, :PhoneNumber
    end
  end
end
