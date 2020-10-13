module Redox
  module Models
    class PCP < OrderingProvider
      property :NPI, from: :npi

      alias_method :npi, :NPI
    end
  end
end
