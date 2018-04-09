require 'test_helper'

class ClientSchedulingCancelTest < Minitest::Test
  def setup
    RedoxEngine.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
    VCR.use_cassette('scheduling/client_init') do
      @client = redox
    end
  end

  def test_cancel_appointment_valid
    VCR.use_cassette('scheduling/cancel/success') do
      cancelled_appt = @client.cancel_appointment(
        visit: booked_visit, patient: patient_identifiers
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil cancelled_appt[:visit]
      assert_equal 'Canceled', cancelled_appt[:visit][:status]
    end
  end

  def test_cancel_appointment_invalid
    VCR.use_cassette('scheduling/cancel/failed') do
      assert_output('Error posting Cancel Appointment.') do
        cancelled_appt = @client.cancel_appointment(
          visit: { p: 'r' }, patient: patient_identifiers
        )
        assert_equal 400, @client.response.code.to_i
        refute_nil cancelled_appt[:errors]
      end
    end
  end
end
