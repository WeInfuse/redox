# frozen_string_literal: true

module Redox
  module Models
    class Notes < AbstractModel
      property :Note, from: :note, required: false

      def note
        self[:Note] = Note.new(self[:Note]) unless self[:Note].is_a?(Redox::Models::Note)
        self[:Note] ||= Note.new
      end
    end
  end
end
