module Redox
  module Models
    class Medication < AbstractModel
      property :Order, required: false, from: :order, default: {}
      property :LotNumber, required: false, from: :lot_number
      property :Dose, required: false, from: :dose, default: {}
      property :Rate, required: false, from: :rate, default: {}
      property :Route, required: false, from: :route, default: {}
      property :Product, required: false, from: :product, default: {}
      property :Components, required: false, from: :components, default: []
      property :OrderedBy, required: false, from: :ordered_by, default: {}
      property :Indications, required: false, from: :indications, default: []
      property :AdministeringProvider, required: false, from: :administering_provider, default: {}

      alias_method :order, :Order
      alias_method :lot_number, :LotNumber
      alias_method :dose, :Dose
      alias_method :rate, :Rate
      alias_method :route, :Route
      alias_method :product, :Product
      alias_method :components, :Components
      alias_method :ordered_by, :OrderedBy
      alias_method :indications, :Indications
      alias_method :administering_provider, :AdministeringProvider
    end
  end
end
