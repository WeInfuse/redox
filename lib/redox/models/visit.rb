module Redox
  module Models
    class Visit < Model
      property :Insurances, from: :insurances, required: false, default: []

      alias_method :insurances, :Insurances

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end
    end
  end
end
