module Redox
  module Models
    class Provider < AbstractModel
      property :ID, required: false, from: :id
      property :IDType, required: false, from: :id_type
      property :FirstName, required: false, from: :first_name
      property :LastName, required: false, from: :last_name

      alias_method :first_name, :FirstName
      alias_method :last_name, :LastName
      alias_method :id, :ID
      alias_method :id_type, :IDType
    end
  end
end
