module Redox
  module Models
    class Demographics < AbstractModel
      property :FirstName, required: false, from: :first_name
      property :MiddleName, required: false, from: :middle_name
      property :LastName, required: false, from: :last_name
      property :RelationToPatient, required: false
      property :EmailAddresses, required: false, default: []
      property :Address, required: false, default: {}
      property :PhoneNumber, required: false, default: {}
      property :Roles, required: false, default: []

      alias_method :first_name, :FirstName
      alias_method :middle_name, :MiddleName
      alias_method :last_name, :LastName
      alias_method :address, :Address
      alias_method :phone_number, :PhoneNumber
      alias_method :roles, 
    end
  end
end
