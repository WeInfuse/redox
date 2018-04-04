module Redox
  # Serialize the Patient response object from Redox
  class Patient
    include Util
    def initialize(patient_hash)
      map_hash_to_attributes(patient_hash.rubyize_keys)
    end
  end
end
