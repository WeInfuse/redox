# frozen_string_literal: true

module Redox
  module Models
    class Financial < AbstractModel
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :Transactions, required: false, from: :transactions, default: []

      alias patient Patient
      alias visit Visit
      alias transactions Transactions
    end
  end
end
