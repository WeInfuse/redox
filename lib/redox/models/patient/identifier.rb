# frozen_string_literal: true

module Redox
  module Models
    class Identifier < AbstractModel
      property :ID, from: :id
      property :IDType, from: :id_type

      alias id ID
      alias id_type IDType
    end
  end
end
