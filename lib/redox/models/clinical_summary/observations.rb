module Redox
  module Models
    class Observations < Model
      property :Code, from: :code, required: false
      property :CodeSystem, from: :code_system, required: false
      property :CodeSystemName, from: :code_system_name, required: false
      property :Name, from: :name, required: false
      property :AltCodes, from: :alt_codes, required: false, default: []
      property :Status, from: :status, required: false
      property :Interpretation, from: :interpretation, required: false
      property :DateTime, from: :date_time, required: false
      property :Value, from: :value, required: false
      property :Units, from: :units, required: false

    end
  end  
end