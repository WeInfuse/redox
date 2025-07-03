# frozen_string_literal: true

module Redox
  module Models
    class Provider < Model
      property :Identifiers, from: :identifiers, required: false, default: []
      property :Demographics, from: :demographics, required: false

      alias identifiers Identifiers

      def demographics
        unless self[:Demographics].is_a?(Redox::Models::Demographics)
          self[:Demographics] = Demographics.new(self[:Demographics])
        end
        self[:Demographics] ||= Demographics.new
      end

      def add_identifier(type:, value:)
        self[:Identifiers] << Identifier.new({ 'ID' => value, 'IDType' => type })

        self
      end
    end
  end
end
