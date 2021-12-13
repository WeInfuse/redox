module Redox
  module Models
    class Administration < AbstractModel
      property :Status, required: false, from: :status
      property :Medication, required: false, from: :medication, default: Redox::Models::Medication.new
      property :StartDate, required: false, from: :start_date
      property :EndDate, required: false, from: :end_date

      alias_method :status, :Status
      alias_method :medication, :Medication
      alias_method :start_date, :StartDate
      alias_method :end_date, :EndDate
    end
  end
end
