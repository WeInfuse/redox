module Redox
  module Models
    class Notes < AbstractModel
      property :Identifiers, from: :identifiers, required: true, default: []
      property :Note, required: true, from: :Redox::Models::Note.new
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      
      alias_method :visit, :Visit
      alias_method :patient, :Patient
      def add_identifier(type: , value: )
        self[:Identifiers] << Identifier.new({'ID' => value, 'IDType' => type})

        return self
      end
    end
  end
end
