module Redox
  module Models
    class Financial < AbstractModel
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :Transactions, required: false, from: :transactions, default: []

      alias_method :patient, :Patient
      alias_method :visit, :Visit
      alias_method :transactions, :Transactions
    end
  end
end
