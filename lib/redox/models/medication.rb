# frozen_string_literal: true

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

      alias order Order
      alias lot_number LotNumber
      alias dose Dose
      alias rate Rate
      alias route Route
      alias product Product
      alias components Components
      alias ordered_by OrderedBy
      alias indications Indications
      alias administering_provider AdministeringProvider
    end
  end
end
