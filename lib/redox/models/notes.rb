module Redox
  module Models
    class Notes < AbstractModel
      property :Note, from: :note, required: false
      property :DataModel, from: :data_model, required: false
      property :EventType, from: :event_type, required: false

      alias_method :data_model, :DataModel
      alias_method :event_type, :EventType
      alias_method :note, :Note

      def note
         self[:Note] = Note.new(self[:Note]) unless self[:Note].is_a?(Redox::Models::Note)
         self[:Note] ||= Note.new
      end
    end
  end
end
