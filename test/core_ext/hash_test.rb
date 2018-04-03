require 'test_helper'

class HashTest < Minitest::Test
  def patient_demo_hash_ruby_keys
    {
      first_name: 'Pedro',
      last_name: 'De Ona'
    }
  end

  def patient_demo_hash_redox_keys
    {
      'FirstName' => 'Pedro',
      'LastName' => 'De Ona'
    }
  end

  def test_symbolize_keys
    sym_keys = patient_demo_hash_redox_keys.symbolize_keys
    assert_equal(
      %i[FirstName LastName],
      sym_keys.keys
    )
  end

  def test_redoxify_keys
    ruby_keys = patient_demo_hash_ruby_keys.keys
    rubyized_keys = patient_demo_hash_redox_keys.rubyize_keys.keys
    assert_equal(
      ruby_keys,
      rubyized_keys
    )
  end
end
