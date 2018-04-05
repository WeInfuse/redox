require 'test_helper'

class ClientPatientTest < Minitest::Test
  def setup
    RedoxEngine.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_add_patient_success
    VCR.use_cassette('patient/new/valid') do
      r = redox
      response = r.add_patient(real_patient)
      assert_equal 200, r.response.code.to_i
      refute_nil response[:patient]
    end
  end

  def test_add_patient_failed
    VCR.use_cassette('patient/new/invalid') do
      r = redox
      assert_output('Error in Patient New.') do
        response = r.add_patient(p: 'e', d: 'r')
        assert_equal 400, r.response.code.to_i
        refute_nil response[:errors]
      end
    end
  end

  def test_search_patient_success
    VCR.use_cassette('patient/search/valid') do
      r = redox
      response = r.search_patient(
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
      )
      assert_equal 200, r.response.code.to_i
      refute response[:errors]
      assert response[:patient]
      assert_equal([{
                     id: '4681',
                     id_type: 'AthenaNet Enterprise ID'
                   }], response[:patient][:identifiers])
    end
  end

  def test_search_patient_failed
    VCR.use_cassette('patient/search/invalid') do
      r = redox
      assert_output 'Error in Patient Search.' do
        response = r.search_patient(
          identifiers: [
            {
              id: 'random id',
              id_type: 'not an id'
            }
          ]
        )
        assert_equal 400, r.response.code.to_i
        refute_nil response[:errors]
      end
    end
  end

  def test_patient_chart_success
    VCR.use_cassette('patient/clinical_summary_get/valid') do
      r = redox
      response = r.get_summary_for_patient(
        identifiers: [{
          'ID' => '4681',
          'IDType' => 'AthenaNet Enterprise ID'
        }]
      )
      assert_equal 200, r.response.code.to_i
      refute response[:errors]
      assert response[:header][:patient][:identifiers]
    end
  end

  def test_patient_chart_failed
    VCR.use_cassette('patient/clinical_summary_get/invalid') do
      r = redox
      assert_output('Error fetching Patient Clinical Summary') do
        response = r.get_summary_for_patient(
          identifiers: [{
            'ID' => 'randomId',
            'IDType' => 'Pedro ID'
          }]
        )
        assert_equal 400, r.response.code.to_i
        refute_nil response[:errors]
      end
    end
  end

  def test_patient_update_success
    VCR.use_cassette('patient/update/valid') do
      r = redox
      updated_patient = real_patient.rubyize_keys
      updated_patient[:identifiers] = [
        { id: '4681', id_type: 'AthenaNet Enterprise ID' }
      ]
      updated_patient[:demographics][:address] = {
        street_address: '100 main street',
        city: 'Miami',
        state: 'FL',
        zip: '33133',
        county: 'Miami-Dade',
        country: 'US'
      }
      response = r.update_patient(updated_patient)
      assert_equal 200, r.response.code.to_i
      refute_nil response[:patient]
    end
  end

  def test_patient_update_failed
    VCR.use_cassette('patient/update/invalid') do
      r = redox
      updated_patient = real_patient.rubyize_keys
      updated_patient[:identifiers] = [
        { id: 'random_id', id_type: 'Pedro ID' }
      ]
      updated_patient[:demographics][:address] = {
        street_address: '100 main street',
        city: 'Miami',
        county: 'Miami-Dade',
        country: 'US'
      }
      assert_output 'Error updating Patient.' do
        response = r.update_patient(updated_patient)
        assert_equal 400, r.response.code.to_i
        refute_nil response[:errors]
      end
    end
  end
end
