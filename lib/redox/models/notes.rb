module Redox
  module Models
    class Notes < AbstractModel
      property :Note, from: :note, required: false
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      
      alias_method :visit, :Visit
      alias_method :patient, :Patient
      alias_method :note, :Note

      def note
         self[:Note] = Note.new(self[:Note]) unless self[:Note].is_a?(Redox::Models::Note)
         self[:Note] ||= Note.new
      end
    end
  end
end
