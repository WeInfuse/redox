module Redox
  module Models
    class Notification < AbstractModel
      property :Credentials, required: false, default: []
      property :FirstName, required: false, from: :first_name
      property :ID, from: :id
      property :IDType, from: :id_type
      property :LastName, required: false, from: :last_name

      alias_method :first_name, :FirstName
      alias_method :id_type, :IDType
      alias_method :id, :ID
      alias_method :last_name, :LastName
    end
  end
end
