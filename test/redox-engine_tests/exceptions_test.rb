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

  def test_redox_test_throws_without_keys
    File.stub(:open, nil) do
      assert_raises(RedoxEngine::APIKeyError) { redox }
    end
  end

  def test_redox_test_circle_ci_style
    File.stub(:open, nil) do
      assert_raises(RedoxEngine::APIKeyError) { redox }
      ENV['REDOX_API_KEY'] = 'test'
      ENV['REDOX_SECRET'] = 'test'
      VCR.use_cassette('client/token/invalid') do
        assert_raises(RedoxEngine::TokenError) { redox }
      end
    end
  end
end
