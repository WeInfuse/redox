require 'test_helper'

class PatientTest < Minitest::Test
  def setup
    @sample = load_sample('patient_search_single_result.response.json', parse: true)
  end

  def test_has_demographics
    assert(@sample[Redox::Models::Patient::KEY][Redox::Models::Demographics::KEY], Redox::Models::Patient.new(@sample).demographics.inner)
  end

  def test_has_identifiers
    assert(@sample[Redox::Models::Patient::KEY][Redox::Models::Identifiers::KEY], Redox::Models::Patient.new(@sample).identifiers.inner)
  end
end
