module RedoxEngine
  # Serialize the Patient response object from RedoxEngine
  class Patient
    include Util
    def initialize(patient_data)
      map_hash_to_attributes(patient_data.rubyize_keys)
    end
  end
end
