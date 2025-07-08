# frozen_string_literal: true

module Redox
  module Models
    class Notification < AbstractModel
      property :Credentials, required: false, default: []
      property :FirstName, required: false, from: :first_name
      property :ID, from: :id
      property :IDType, from: :id_type
      property :LastName, required: false, from: :last_name

      alias first_name FirstName
      alias id_type IDType
      alias id ID
      alias last_name LastName
    end
  end
end
