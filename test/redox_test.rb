require 'test_helper'

class RedoxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Redox::VERSION
  end

  def setup
    Redox.configure do |r|
      r.api_key = ENV['Redox_key']
      r.secret = ENV['Redox_secret']
    end
  end

  def test_configure_method
    Redox.configure do |r|
      r.api_key = 'test'
      r.secret = 'test'
    end
    assert_equal(Redox.api_key, 'test')
    assert_equal(Redox.secret, 'test')
  end

  def test_add_patient
    Redox.configure do |r|
      r.api_key = 'test'
      r.secret = 'test'
    end

    VCR.use_cassette('patient/new_test') do
      redox.add_patient(patient)
    end
  end

  private

  def redox
    VCR.use_cassette('client/new/get_token_test') do
      Redox::Client.new(
        source: source,
        destinations: destinations,
        test: true
      )
    end
  end

  def redox_keys
    file = File.open(File.join(__dir__, 'redox_keys.yml'))
    if file
      return YAML.load(file)
    end
    raise 'Keys not found. Please save real redox keys in test/redox_keys.yml to run tests'
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
