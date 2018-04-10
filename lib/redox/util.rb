module Redox
  # utility methods for serializing responses
  module Util
    def map_hash_to_attributes(hash)
      hash.map do |key, val|
        define_singleton_method(key.to_sym) do
          val
        end
        map_hash_to_attributes(val) if val.respond_to? :each_key
      end
    end
  end
end
