module Redox
  # Serialize the Patient response object from Redox
  class Patient
    include Util
    def initialize(patient_data)
      map_hash_to_attributes(patient_data.rubyize_keys)
    end
  end
end
