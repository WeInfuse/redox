# frozen_string_literal: true

module Redox
  module Models
    class OrderingProvider < AbstractModel
      property :ID, required: false, from: :id
      property :IDType, required: false, from: :id_type
      property :FirstName, required: false, from: :first_name
      property :LastName, required: false, from: :last_name

      alias first_name FirstName
      alias last_name LastName
      alias id ID
      alias id_type IDType
    end
  end
end
