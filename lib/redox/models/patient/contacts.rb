# frozen_string_literal: true

module Redox
  module Models
    class Contact < AbstractModel
      property :FirstName, required: false, from: :first_name
      property :MiddleName, required: false, from: :middle_name
      property :LastName, required: false, from: :last_name
      property :RelationToPatient, required: false
      property :EmailAddresses, required: false, default: []
      property :Address, required: false, default: {}
      property :PhoneNumber, required: false, default: {}
      property :Roles, required: false, default: []

      alias first_name FirstName
      alias middle_name MiddleName
      alias last_name LastName
      alias address Address
      alias phone_number PhoneNumber
    end
  end
end
