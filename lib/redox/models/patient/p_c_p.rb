# frozen_string_literal: true

module Redox
  module Models
    class PCP < OrderingProvider
      property :NPI, from: :npi

      alias npi NPI
    end
  end
end
