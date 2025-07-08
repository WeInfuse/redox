# frozen_string_literal: true

module Redox
  module Models
    class Administration < AbstractModel
      property :Status, required: false, from: :status
      property :Medication, required: false, from: :medication, default: Redox::Models::Medication.new
      property :StartDate, required: false, from: :start_date
      property :EndDate, required: false, from: :end_date

      alias status Status
      alias medication Medication
      alias start_date StartDate
      alias end_date EndDate
    end
  end
end
