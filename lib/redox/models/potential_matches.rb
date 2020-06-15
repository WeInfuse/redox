module Redox
  module Models
    class PotentialMatches < Array
      def initialize(data = [])
        if false == data.nil?
          super(data.map {|patient| Redox::Models::Patient.new(patient) })
        else
          super([])
        end
      end
    end
  end
end
