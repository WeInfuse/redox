require 'test_helper'

class ClientSchedulingTest < Minitest::Test
  def setup
    Redox.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
    VCR.use_cassette('scheduling/client_init') do
      @client = redox
    end
  end

  def test_fetch_booked_slots_no_options
    VCR.use_cassette('scheduling/booked_slots/no_options') do
      slots = @client.get_booked_slots(visit: visit)
      assert_equal 200, @client.response.code.to_i
      refute_nil slots[:visits]
    end
  end

  def test_fetch_booked_slots_start_time_string_given
    VCR.use_cassette('scheduling/booked_slots/start_time_given') do
      slots = @client.get_booked_slots(
        visit: visit,
        start_time: Time.new(2018, 1, 15).iso8601
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil slots[:visits]
    end
  end

  def test_fetch_booked_slots_start_time_object_given
    VCR.use_cassette('scheduling/booked_slots/start_time_given_obj') do
      slots = @client.get_booked_slots(
        visit: visit,
        start_time: Time.new(2018, 1, 15)
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil slots[:visits]
    end
  end

  def test_fetch_booked_slots_end_time_string_given
    VCR.use_cassette('scheduling/booked_slots/end_time_given') do
      slots = @client.get_booked_slots(
        visit: visit,
        end_time: Time.new(2018, 4, 15).iso8601
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil slots[:visits]
    end
  end

  def test_fetch_booked_slots_end_time_object_given
    VCR.use_cassette('scheduling/booked_slots/end_time_given_obj') do
      slots = @client.get_booked_slots(
        visit: visit,
        end_time: Time.new(2018, 4, 15)
      )
      assert_equal 200, @client.response.code.to_i
      refute_nil slots[:visits]
    end
  end
end
