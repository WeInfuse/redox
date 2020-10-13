module Redox
  module Models
    class Identifier < AbstractModel
      property :ID, from: :id
      property :IDType, from: :id_type

      alias_method :id, :ID
      alias_method :id_type, :IDType
    end
  end
end
