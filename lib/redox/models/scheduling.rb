# frozen_string_literal: true

module Redox
  module Models
    class Scheduling < AbstractModel
      property :Visit, required: false, from: :visit, default: Redox::Models::Visit.new
      property :Patient, required: false, from: :patient, default: Redox::Models::Patient.new
      property :AppointmentInfo, required: false, from: :appointment_info, default: []

      alias patient Patient
      alias visit Visit
      alias appointment_info AppointmentInfo

      def add_appointment_info(code: nil, codeset: nil, description: nil, value: nil)
        self[:AppointmentInfo] << {
          Code: code,
          Codeset: codeset,
          Description: description,
          Value: value
        }

        self
      end
    end
  end
end
