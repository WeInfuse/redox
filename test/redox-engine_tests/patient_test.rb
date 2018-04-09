require 'test_helper'

class PatientTest < Minitest::Test
  def setup
    RedoxEngine.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_attributes_map_from_response
    VCR.use_cassette('client/new/token') do
      pt = RedoxEngine::Patient.new(client: redox, patient_data: real_patient)
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
end
