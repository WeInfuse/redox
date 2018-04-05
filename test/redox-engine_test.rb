require 'test_helper'

class RedoxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RedoxEngine::VERSION
  end

  def setup
    RedoxEngine.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_configure_method
    RedoxEngine.configure do |r|
      r.api_key = 'test'
      r.secret = 'test'
    end
    assert_equal(RedoxEngine.api_key, 'test')
    assert_equal(RedoxEngine.secret, 'test')
  end
end
