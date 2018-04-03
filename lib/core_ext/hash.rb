# Help us deal with hashes with various key shapes/types
class Hash
  # recursively transform keys according to a given block
  def transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] = if value.respond_to?(:each_index)
                             value.map { |e| e.transform_keys(&block) rescue e }
                           else
                             value.transform_keys(&block) rescue value
                           end
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
      next key if key =~ /["A-Z]/
      key.to_s.split('_').map(&:capitalize).join
    end
  end

  # transform RedoxCase string keys to ruby symbol keys
  def rubyize_keys
    transform_keys do |key|
      begin
        next :id if key == 'ID'
        new_key = key.chars.map { |c| c =~ /[A-Z]+/ ? "_#{c.downcase}" : c }
        new_key[0] = new_key[0].slice(1)
        new_key.join.to_sym
      rescue StandardError
        key
      end
    end
  end
end
