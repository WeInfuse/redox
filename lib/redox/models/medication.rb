module Redox
  module Models
    class Medication < AbstractModel
      property :Order, required: false, from: :order, default: {}
      property :LotNumber, required: false, from: :lot_number
      property :Dose, required: false, from: :dose, default: {}
      property :Rate, required: false, from: :rate, default: {}
      property :Route, required: false, from: :route, default: {}
      property :Product, required: false, from: :product, default: {}

      alias_method :order, :Order
      alias_method :lot_number, :LotNumber
      alias_method :dose, :Dose
      alias_method :rate, :Rate
      alias_method :route, :Route
      alias_method :product, :Product
    end
  end
end
