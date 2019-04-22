module Redox
  module Models
    class PCP < Model
      property :NPI, from: :npi
      property :FirstName, required: false, from: :first_name
      property :LastName, required: false, from: :last_name

      alias_method :npi, :NPI
      alias_method :first_name, :FirstName
      alias_method :last_name, :LastName
    end
  end
end
