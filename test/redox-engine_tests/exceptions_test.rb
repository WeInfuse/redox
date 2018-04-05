require 'test_helper'

class ExceptionsTest < Minitest::Test
  def test_redox_key_error
    RedoxEngine.configure do |r|
      r.api_key = nil
      r.secret = nil
    end
    assert_raises(RedoxEngine::APIKeyError) { redox }
  end

  def test_redox_token_error
    RedoxEngine.configure do |r|
      r.api_key = 'bad'
      r.secret = 'keys'
    end
    VCR.use_cassette('client/new/token_invalid_key') do
      assert_raises(RedoxEngine::TokenError) { redox }
    end
  end
end
