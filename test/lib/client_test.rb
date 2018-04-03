require 'test_helper'

class ClientTest < Minitest::Test
  def setup
    Redox.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_token_fetch
    VCR.use_cassette('client/new/token') do
      r = redox
      refute_nil r.access_token
    end
  end

  def test_init_with_token
    r = redox(access: '9c1dc378-c782-4791-a41f-bdc2606a6d6b')
    assert_equal '9c1dc378-c782-4791-a41f-bdc2606a6d6b', r.access_token
  end

  def test_token_fetch_with_refresh
    VCR.use_cassette('client/new/token_with_refresh') do
      r = redox(refresh: 'aeb9a5b4-d670-4990-9b79-52ce98a00fa3')
      refute_nil r.access_token
    end
  end

  def test_token_bad_keys
    Redox.configure do |r|
      r.api_key = 'bad'
      r.secret = 'keys'
    end
    VCR.use_cassette('client/new/token_invalid_key') do
      assert_raises(Redox::TokenError) do
        redox
      end
    end
  end

  def test_add_patient
    VCR.use_cassette('client/new/token') do
      r = redox
      VCR.use_cassette('patient/new_test') { r.add_patient(patient) }
    end
  end

  private

  def redox(refresh: nil, access: nil)
    Redox::Client.new(
      source: source,
      destinations: destinations,
      test: true,
      token: access,
      refresh_token: refresh
    )
  end

  def request_body
    {
      Meta: {
        DataModel: 'PatientAdmin',
        EventType: 'NewPatient',
        Test: true,
        Source: source,
        Destinations: destinations
      },
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
