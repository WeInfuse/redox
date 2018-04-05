require 'test_helper'

class PatientTest < Minitest::Test
  def test_attributes_map_from_response
    pt = RedoxEngine::Patient.new(real_patient)
    assert_equal [
      {
        id: '0000000001',
        id_type: 'MR'
      },
      {
        id: 'e167267c-16c9-4fe3-96ae-9cff5703e90a',
        id_type: 'EHRID'
      },
      {
        id: 'a1d4ee8aba494ca',
        id_type: 'NIST'
      }
    ], pt.identifiers
  end
end
