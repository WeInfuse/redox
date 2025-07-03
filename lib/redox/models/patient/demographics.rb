# frozen_string_literal: true

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
      property :MaritalStatus, required: false, from: :marital_status
      property :IsDeceased, required: false
      property :DeathDateTime, required: false
      property :Language, required: false, from: :language
      property :EmailAddresses, required: false, default: []
      property :Citizenship, required: false, default: []
      property :Address, required: false, default: {}
      property :PhoneNumber, required: false, default: {}

      alias first_name FirstName
      alias middle_name MiddleName
      alias last_name LastName
      alias dob DOB
      alias ssn SSN
      alias sex Sex
      alias race Race
      alias marital_status MaritalStatus
      alias language Language
      alias address Address
      alias phone_number PhoneNumber
    end
  end
end
