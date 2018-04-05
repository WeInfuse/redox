module TestHelpers
  KEY_ERROR_MSG = """
  Keys not found. Please save real redox keys in test/redox_keys.yml to run tests
  """

  def redox_keys
    begin
      file = File.open(File.join(__dir__, 'redox_keys.yml'))
      YAML.safe_load(file).symbolize_keys
    rescue
      raise RedoxEngine::APIKeyError,
            KEY_ERROR_MSG
    end
  end

  def real_patient
    {
      "Identifiers" => [
        {
            "ID" => "0000000001",
            "IDType" => "MR"
        },
        {
            "ID" => "e167267c-16c9-4fe3-96ae-9cff5703e90a",
            "IDType" => "EHRID"
        },
        {
            "ID" => "a1d4ee8aba494ca",
            "IDType" => "NIST"
        }
      ],
      "Demographics" => {
        "FirstName" => "Timothy",
        "MiddleName" => "Paul",
        "LastName" => "Bixby",
        "DOB" => "2008-01-06",
        "SSN" => "101-01-0001",
        "Sex" => "Male",
        "Race" => "Asian",
        "IsHispanic" => nil,
        "MaritalStatus" => "Single",
        "IsDeceased" => nil,
        "DeathDateTime" => nil,
        "PhoneNumber" => {
            "Home" => "+18088675301",
            "Office" => nil,
            "Mobile" => nil
        },
        "EmailAddresses" => [],
        "Language" => "en",
        "Citizenship" => [],
        "Address" => {
            "StreetAddress" => "4762 Hickory Street",
            "City" => "Monroe",
            "State" => "WI",
            "ZIP" => "53566",
            "County" => "Green",
            "Country" => "US"
        }
      }
    }
  end

  def dummy_redox(refresh: nil, access: nil)
    RedoxEngine::Client.new(
      source: source,
      destinations: destinations,
      test_mode: true,
      token: access,
      refresh_token: refresh
    )
  end

  def redox(refresh: nil, access: nil)
    RedoxEngine::Client.new(
      source: real_source,
      destinations: real_destinations,
      test_mode: true,
      token: access,
      refresh_token: refresh
    )
  end

  def request_body_new_patient
    {
      'Meta' => {
        'DataModel' => 'PatientAdmin',
        'EventType' => 'NewPatient',
        'Test' => true,
        'Source' => source,
        'Destinations' => destinations
      },
      'Patient' => patient
    }
  end

  def source
    {
      'Name' => 'RedoxEngine Dev Tools',
      'ID' => '4-5-6'
    }
  end

  def real_source
    redox_keys[:source_data]
  end

  def destinations
    [
      {
        'Name' => 'RedoxEngine EMR',
        'ID' => '7-8-9'
      }
    ]
  end

  def real_destinations
    redox_keys[:destinations_data]
  end

  def patient
    {
      'Identifiers' => [],
      'Demographics' => {
        'FirstName' => 'Joe'
      }
    }
  end

  def visit
    {
      'Reason' => nil,
      'AttendingProviders' => [
        {
          'ID' => 108
        }
      ],
      'Location' => {
        'Department' => 150
      }
    }
  end
end
