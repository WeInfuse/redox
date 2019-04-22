require 'test_helper'

class ModelTest < Minitest::Test
  def setup
    @sample = load_sample('patient_search_single_result.response.json', parse: true)
  end

  def test_valid_returns_true_for_hash_with_patient
    assert(Redox::Models::Patient.new(@sample).valid?)
  end

  def test_valid_returns_false_for_hash_missing_patient
    @sample["_patient_"] = @sample.delete("Patient")

    assert(false == Redox::Models::Patient.new(@sample).valid?)
  end

  def test_valid_returns_false_for_not_hash
    assert(false == Redox::Models::Patient.new(nil).valid?)
    assert(false == Redox::Models::Patient.new('hi').valid?)
  end

  def test_inner_returns_patient_value
    assert_equal(@sample[Redox::Models::Patient::KEY], Redox::Models::Patient.new(@sample).inner)
  end
end
