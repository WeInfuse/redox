module Redox
  module Models
    class PCP < Provider
      property :NPI, from: :npi

      alias_method :npi, :NPI
    end
  end
end
