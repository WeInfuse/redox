require 'test_helper'

class RedoxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Redox::VERSION
  end

  def setup
    stub_request(:post, 'https://api.redoxengine.com/auth/authenticate')
      .with(body: { apiKey: '1-2-3', secret: 'xJp3Ba' },
            headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: { accessToken: 'let.me.in' }.to_json)

    stub_request(:post, 'https://api.redoxengine.com/endpoint')
      .with(body: hash_including(request_body),
            headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: '{ "Success": true }')
  end

  def test_add_patient
    redox = Redox::Redox.new(
      api_key: '1-2-3',
      secret: 'xJp3Ba',
      source: source,
      destinations: destinations,
      test: true
    )

    redox.add_patient(patient)
  end

  private

  def request_body
    {
      Meta: hash_including(
        DataModel: 'PatientAdmin',
        EventType: 'NewPatient',
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
