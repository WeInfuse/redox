# Help us deal with hashes with various key shapes/types
class Hash
  # Rails method, find at
  # activesupport/lib/active_support/core_ext/hash/keys.rb, line 8
  def transform_keys
    return enum_for(:transform_keys) unless block_given?
    result = self.class.new
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

  # Rails method, find at
  # activesupport/lib/active_support/core_ext/hash/keys.rb, line 50
  def symbolize_keys
    transform_keys do |key|
      begin
        key.to_sym
      rescue StandardError
        key
      end
    end
  end

  # transform camel_case (symbol) keys to RedoxCase string keys
  def redoxify_keys
    transform_keys do |key|
      begin
        key.to_s.split('_').map(&:capitalize).join
      rescue StandardError
        key
      end
    end
  end

  # transform RedoxCase string keys to ruby symbol keys
  def rubyize_keys
    transform_keys do |key|
      begin
        new_key = key.chars.map { |c| c =~ /[A-Z]/ ? "_#{c.downcase}" : c }
        new_key[0] = new_key[0].slice(1)
        new_key.join.to_sym
      rescue StandardError
        key
      end
    end
  end
end
