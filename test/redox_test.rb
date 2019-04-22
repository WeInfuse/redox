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
      facility_code: '1234',
      test: true
    )

    update_sample = load_sample('patient_search_single_result.response.json', parse: true)
    update_sample['Meta'].merge!(Redox::Models::Patient::UPDATE[:meta])
    create_sample = load_sample('patient_search_single_result.response.json', parse: true)
    create_sample['Meta'].merge!(Redox::Models::Patient::ADD[:meta])

    @auth_stub = stub_request(:post, File.join(Redox::Redox::DEFAULT_URI, Redox::Authentication::ENDPOINT))
      .with(body: { apiKey: '1-2-3', secret: 'xJp3Ba' },
            headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: { accessToken: 'let.me.in' }.to_json)

    stub_request(:post, File.join(Redox::Redox::DEFAULT_URI, Redox::Authentication::ENDPOINT))
      .with(body: { apiKey: 'wrong', secret: 'xJp3Ba' },
            headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 401, body: 'Invalid request')

    @update_patient_stub = stub_request(:post, File.join(Redox::Redox::DEFAULT_URI, Redox::Models::Patient::UPDATE[:endpoint]))
      .with(body: hash_including('Meta' => hash_including('EventType' => 'PatientUpdate')),
            headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: update_sample.to_json)

    @add_patient_stub = stub_request(:post, File.join(Redox::Redox::DEFAULT_URI, Redox::Models::Patient::ADD[:endpoint]))
      .with(body: hash_including('Meta' => hash_including('EventType' => 'NewPatient')),
            headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: create_sample.to_json)

    @search_patients_stub = stub_request(:post, File.join(Redox::Redox::DEFAULT_URI, Redox::Models::Patient::SEARCH[:endpoint]))
      .with(headers: { 'Authorization' => 'Bearer let.me.in' })
      .to_return(status: 200, body: load_sample('patient_search_single_result.response.json'))
  end

  def test_auth_only_gets_auth_first_time
    @redox.add_patient(patient)
    @redox.add_patient(patient)

    assert_requested(@auth_stub, times: 1)
  end

  def test_auth_fails_returns_reasonable_error
    redox = Redox::Redox.new(
      api_key: 'wrong',
      secret: 'xJp3Ba'
    )

    error = assert_raises(Redox::RedoxException) { redox.add_patient(patient) }

    assert_match(/Failed Authenticat/, error.message)
    assert_match(/HTTP code: 401/, error.message)
    assert_match(/MSG: Invalid request/, error.message)
  end

  %w[add_patient update_patient search_patients].each do |request_type|
    define_method :"test_#{request_type}_returns_valid_redox_response_with_patient" do
      stub    = instance_variable_get("@#{request_type}_stub")
      stub.with(body: hash_including('Meta' => hash_including('FacilityCode' => '1234')))
      results = @redox.send("#{request_type}", patient)

      assert(results.is_a?(Redox::Response))
      assert(results.success?)
      assert(results.model.is_a?(Redox::Models::Patient))
      assert(results.model.valid?)
      assert_requested(stub)
    end

    define_method :"test_#{request_type}_accepts_meta_override" do
      meta    = Redox::Models::Meta.new
      meta.facility_code = '851736'
      stub = instance_variable_get("@#{request_type}_stub")
      stub.with(body: hash_including('Meta' => hash_including('FacilityCode' => meta.inner['FacilityCode'])))

      results = @redox.send("#{request_type}", patient, meta)

      assert_requested(stub)
    end
  end

  private

  def source
    Redox::Models::Meta.build_subscription('Redox Dev Tools', '4-5-6')
  end

  def destinations
    [ Redox::Models::Meta.build_subscription('Redox EMR', '7-8-9') ]
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
