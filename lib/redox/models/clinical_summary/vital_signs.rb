module Redox
  module Models
    class VitalSigns < Model
      property :DateTime, from: :date_time, required: false
      property :Observations, from: :observations, required: false, default: []

      alias_method :observations, :Observations

      def observations
        self[:Observations] = self[:Observations].map {|observation| observation.is_a?(Redox::Models::Observations) ? observation : Observations.new(observation)}
      end
         
    end
  end
end