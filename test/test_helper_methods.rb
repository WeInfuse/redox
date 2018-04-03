module TestHelpers
  def redox_keys
    file = File.open(File.join(__dir__, 'redox_keys.yml'))
    return YAML.safe_load(file).symbolize_keys if file
    raise StandardError, 'Keys not found. Please save real redox keys in \
    test/redox_keys.yml to run tests'
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
