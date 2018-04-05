require 'test_helper'

class ClientSchedulingNewTest < Minitest::Test
  def setup
    RedoxEngine.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
    VCR.use_cassette('scheduling/client_init') do
      @client = redox
    end
  end

  def test_book_new_appointment_valid
    VCR.use_cassette('scheduling/new/success') do
      booked_appt = @client.add_appointment(
        visit: booked_visit, patient: patient_identifiers
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil booked_appt[:visit]
      refute_nil booked_appt[:patient]
    end
  end

  def test_book_new_appointment_invalid
    VCR.use_cassette('scheduling/new/failed') do
      assert_output('Error posting New Appointment.') do
        booked_appt = @client.add_appointment(
          visit: { data: 'random' }, patient: {}
        )
        assert_equal 400, @client.response.code.to_i
        refute_nil booked_appt[:errors]
      end
    end
  end
end
