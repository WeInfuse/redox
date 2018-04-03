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
    VCR.use_cassette('client/new/token') do |cassette|
      token_response = cassette.http_interactions.interactions[0].response.to_hash
      refresh_token = JSON.parse(token_response['body']['string'])['refreshToken']
      VCR.use_cassette('client/new/token_with_refresh') do
        r = redox(refresh: refresh_token)
        refute_nil r.access_token
      end
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
      VCR.use_cassette('patient/new_test') { r.add_patient(real_patient) }
    end
  end

  private

  def test_redox(refresh: nil, access: nil)
    Redox::Client.new(
      source: source,
      destinations: destinations,
      test: true,
      token: access,
      refresh_token: refresh
    )
  end

  def redox(refresh: nil, access: nil)
    Redox::Client.new(
      source: real_source,
      destinations: real_destinations,
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

  def real_source
    redox_keys[:source_data]
  end

  def destinations
    [
      {
        Name: 'Redox EMR',
        ID: '7-8-9'
      }
    ]
  end

  def real_destinations
    redox_keys[:destinations_data]
  end

  def patient
    {
      Identifiers: [],
      Demographics: {
        FirstName: 'Joe'
      }
    }
  end

  def real_patient
    {
      "Identifiers": [
         {
            "ID": "0000000001",
            "IDType": "MR"
         },
         {
            "ID": "e167267c-16c9-4fe3-96ae-9cff5703e90a",
            "IDType": "EHRID"
         },
         {
            "ID": "a1d4ee8aba494ca",
            "IDType": "NIST"
         }
      ],
      "Demographics": {
         "FirstName": "Timothy",
         "MiddleName": "Paul",
         "LastName": "Bixby",
         "DOB": "2008-01-06",
         "SSN": "101-01-0001",
         "Sex": "Male",
         "Race": "Asian",
         "IsHispanic": nil,
         "MaritalStatus": "Single",
         "IsDeceased": nil,
         "DeathDateTime": nil,
         "PhoneNumber": {
            "Home": "+18088675301",
            "Office": nil,
            "Mobile": nil
         },
         "EmailAddresses": [],
         "Language": "en",
         "Citizenship": [],
         "Address": {
            "StreetAddress": "4762 Hickory Street",
            "City": "Monroe",
            "State": "WI",
            "ZIP": "53566",
            "County": "Green",
            "Country": "US"
         }
      }
    }
  end
end
