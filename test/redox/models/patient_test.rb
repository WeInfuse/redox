require 'test_helper'

class PatientTest < Minitest::Test
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

  def test_raw_returns_patient_value
    assert_equal(@sample[Redox::Models::Patient::KEY], Redox::Models::Patient.new(@sample).raw)
  end

  def test_has_demographics
    assert(@sample[Redox::Models::Patient::KEY][Redox::Models::Demographics::KEY], Redox::Models::Patient.new(@sample).demographics.raw)
  end

  def test_has_identifiers
    assert(@sample[Redox::Models::Patient::KEY][Redox::Models::Identifiers::KEY], Redox::Models::Patient.new(@sample).identifiers.raw)
  end
end
