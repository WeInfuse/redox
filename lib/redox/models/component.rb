# frozen_string_literal: true

module Redox
  module Models
    class Component < AbstractModel
      property :ID, required: false, from: :id
      property :Name, required: false, from: :name
      property :Value, required: false, from: :value

      alias id ID
      alias name Name
      alias value Value
    end
  end
end
