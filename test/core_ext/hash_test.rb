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

  def deep_hash
    {
      'FirstName' => 'Pedro',
      'HashKey' => {
        'OtherName' => 'Not Pedro'
      },
      'ArrayKey' => [
        { 'YetAnotherName' => 'Not Pedro' },
        'non Hash element'
      ],
      'DeepHashKey' => {
        'DeeperHashKey' => {
          'DeepestHashKey' => {
            'DeepKey' => 'DeepValue'
          }
        }
      }
    }
  end

  def transformed_deep_hash
    {
      first_name: 'Pedro',
      hash_key: {
        other_name: 'Not Pedro'
      },
      array_key: [
        { yet_another_name: 'Not Pedro' },
        'non Hash element'
      ],
      deep_hash_key: {
        deeper_hash_key: {
          deepest_hash_key: {
            deep_key: 'DeepValue'
          }
        }
      }
    }
  end

  def test_symbolize_keys
    sym_keys = patient_demo_hash_redox_keys.symbolize_keys
    assert_equal(
      %i[FirstName LastName],
      sym_keys.keys
    )
  end

  def test_rubyize_keys
    ruby_keys = patient_demo_hash_ruby_keys.keys
    rubyized_keys = patient_demo_hash_redox_keys.rubyize_keys.keys
    assert_equal(
      ruby_keys,
      rubyized_keys
    )
  end

  def test_redoxify_keys
    redox_keys = patient_demo_hash_redox_keys.keys
    redoxified_keys = patient_demo_hash_ruby_keys.redoxify_keys.keys
    assert_equal(
      redox_keys,
      redoxified_keys
    )
  end

  def test_redoxify_keys_already_redox_keys
    redox_keys = patient_demo_hash_redox_keys.keys
    redoxified_redox_keys = patient_demo_hash_redox_keys.redoxify_keys.keys
    assert_equal(
      redox_keys,
      redoxified_redox_keys
    )
  end

  def test_deep_transform_keys_rubyize
    assert_equal transformed_deep_hash, deep_hash.rubyize_keys
  end

  def test_deep_transform_keys_redoxify
    assert_equal deep_hash, transformed_deep_hash.redoxify_keys
  end
end
