# Help us deal with hashes with various key shapes/types
class Hash
  # recursively transform keys according to a given block
  def transform_keys(&block)
    map do |key, value|
      [
        yield(key),
        transform_value(value, &block)
      ]
    end.to_h
  end

  def transform_value(value, &block)
    if value.respond_to?(:each_index)
      value.map do |elem|
        elem.transform_keys(&block) rescue elem
      end
    else
      value.transform_keys(&block) rescue value
    end
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
      key = key.to_s
      next 'IDType' if key == 'id_type'
      next key if key =~ /^([A-Z]{1}[a-z]+)+/
      next key.upcase if key =~ /^[a-z]{2,3}$/
      key.split('_').map(&:capitalize).join
    end
  end

  # transform RedoxCase string keys to ruby symbol keys
  def rubyize_keys
    transform_keys do |key|
      key = key.to_s
      next :id_type if key == 'IDType'
      next key.downcase.to_sym if key =~ /[A-Z]{2,3}/
      new_key = key.chars.map { |c| c =~ /[A-Z]/ ? "_#{c.downcase}" : c }.join
      new_key = new_key[0] == '_' ? new_key[1..-1] : new_key
      new_key.to_sym
    end
  end
end
