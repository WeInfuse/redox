require 'test_helper'

class ExceptionsTest < Minitest::Test
  def test_redox_key_error
    Redox.configure do |r|
      r.api_key = nil
      r.secret = nil
    end
    assert_raises(Redox::APIKeyError) { redox }
  end

  def test_redox_token_error
    Redox.configure do |r|
      r.api_key = 'bad'
      r.secret = 'keys'
    end
    VCR.use_cassette('client/new/token_invalid_key') do
      assert_raises(Redox::TokenError) { redox }
    end
  end

  def test_redox_test_throws_without_keys
    File.stub(:open, nil) do
      assert_raises(Redox::APIKeyError) { redox }
    end
  end
end
