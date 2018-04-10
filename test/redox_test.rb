require 'test_helper'

class RedoxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Redox::VERSION
  end

  def setup
    Redox.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
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
end
