require 'test_helper'

class RedoxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Redox::VERSION
  end

  def setup
    @redox = Redox::Redox.new(
      api_key: '1-2-3',
      secret: 'xJp3Ba',
      source: source,
      destinations: destinations,
      test: true
    )

    stub_request(:post, 'https://api.redoxengine.com/auth/authenticate')
      .with(body: { apiKey: '1-2-3', secret: 'xJp3Ba' },
            headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: { accessToken: 'let.me.in' }.to_json)

    stub_request(:post, 'https://api.redoxengine.com/auth/authenticate')
      .with(body: { apiKey: 'wrong', secret: 'xJp3Ba' },
            headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 401, body: 'Invalid request')

    stub_request(:post, 'https://api.redoxengine.com/endpoint')
      .with(body: hash_including(request_body),
            headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: '{ "Success": true }')

    stub_request(:post, 'https://api.redoxengine.com/endpoint')
      .with(body: hash_including(request_body('NewPatient')),
            headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: '{ "Success": true }')

    stub_request(:post, 'https://api.redoxengine.com/query')
      .with(headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: load_sample('patient_search_single_result.response.json'))
  end

  def test_auth_fails_returns_reasonable_error
    redox = Redox::Redox.new(
      api_key: 'wrong',
      secret: 'xJp3Ba',
      source: source,
      destinations: destinations,
      test: true
    )

    error = assert_raises { redox.add_patient(patient) }

    assert_match(/Failed to authenticate/, error.message)
  end

  def test_add_patient
    @redox.add_patient(patient)
  end

  def test_update_patient
    @redox.update_patient(patient)
  end

  def test_search_patients
    results = @redox.search_patients(patient)

    assert(results.is_a?(Hash))
    assert(results.include?("Meta"))
  end

  private

  def request_body(event_type='PatientUpdate')
    {
      Meta: hash_including(
        DataModel: 'PatientAdmin',
        EventType: event_type,
        Test: true,
        Source: source,
        Destinations: destinations
      ),
      Patient: patient
    }
  end

  def source
    {
      Name: 'Redox Dev Tools',
      ID: '4-5-6'
    }
  end

  def destinations
    [
      {
        Name: 'Redox EMR',
        ID: '7-8-9'
      }
    ]
  end

  def patient
    {
      Identifiers: [],
      Demographics: {
        FirstName: 'Joe'
      }
    }
  end
end
