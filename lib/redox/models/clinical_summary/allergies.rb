module Redox
  module Models
    class Allergies < Model
      property :Type, from: :type, required: false, default: {}
      property :Substance, from: :substance, required: false, default: {}
      property :Reaction, from: :reaction, required: false, default: []
      property :Severity, from: :severity, required: false, default: {}
      property :Criticality, from: :criticality, required: false, default: {}
      property :Status, from: :status, required: false, default: {}
      property :StartDate, from: :start_date, required: false
      property :EndDate, from: :end_date, required: false
      property :Comment, from: :comment, required: false

    end
  end  
end