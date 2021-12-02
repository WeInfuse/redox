module Redox
  module Models
    class Component < AbstractModel
      property :Id, required: false, from: :id
      property :Name, required: false, from: :name
      property :Value, required: false, from: :value

      alias_method :id, :ID
      alias_method :name, :Name
      alias_method :value, :Value
    end
  end
end
