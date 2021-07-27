module Redox
  module Models
    class Encounters < Model
      property :Identifiers, from: :identifiers, required: false, default: []
      
      alias_method :identifiers, :Identifiers

      def add_identifier(type: , value: )
        self[:Identifiers] << Identifier.new({'ID' => value, 'IDType' => type})

        return self
      end
    end
  end  
end