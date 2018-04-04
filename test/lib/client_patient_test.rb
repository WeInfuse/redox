require 'test_helper'

class ClientPatientTest < Minitest::Test
  def setup
    Redox.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_add_patient_success
    VCR.use_cassette('patient/new_test') do
      r = redox
      response = r.add_patient(real_patient)
      assert_equal 200, r.response.code.to_i
      refute_nil response[:patient]
    end
  end

  def test_add_patient_failed
    VCR.use_cassette('patient/new_test_patient_invalid') do
      r = redox
      response = r.add_patient({ p: 'e', d: 'r'})
      assert_equal 400, r.response.code.to_i
      refute_nil response[:errors]
    end
  end

  def test_search_patient_success
    VCR.use_cassette('patient/search/valid') do
      r = redox
      response = r.search_patient({
        demographics: {
          first_name: 'Timothy',
          last_name: 'bixby',
          dob: '2008-01-06',
          sex: 'Male',
          address: {
            street_address: '4762 Hickory Street',
            city: 'Monroe',
            state: 'WI',
            ZIP: '53566',
            country: 'USA'
          }
        }
      })
      assert_equal 200, r.response.code.to_i
      refute response[:errors]
      assert response[:patient]
      assert_equal({
        :id => '4681',
        :id_type => 'AthenaNet Enterprise ID'
      }, response[:patient][:identifiers][0])
    end
  end

  def test_search_patient_failed
    VCR.use_cassette('patient/search/invalid') do
      r = redox
      response = r.search_patient({ 
        identifiers: [
          {
            id: 'random id',
            id_type: 'not an id'
          }
        ]
      })
      assert_equal 400, r.response.code.to_i
      refute_nil response[:errors]
    end
  end
end