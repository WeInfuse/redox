require 'test_helper'

class ClientTest < Minitest::Test
  def setup
    Redox.configure do |r|
      r.api_key = redox_keys[:api_key]
      r.secret = redox_keys[:secret]
    end
  end

  def test_token_fetch
    VCR.use_cassette('client/new/token') { refute_nil redox.access_token }
  end

  def test_init_with_token
    r = redox(access: '9c1dc378-c782-4791-a41f-bdc2606a6d6b')
    assert_equal '9c1dc378-c782-4791-a41f-bdc2606a6d6b', r.access_token
  end

  def test_token_fetch_with_refresh
    VCR.use_cassette('client/new/token') do |cassette|
      token_response = cassette.http_interactions.interactions[0].response
      response_body = token_response.to_hash['body']['string']
      refresh_token = JSON.parse(response_body)['refreshToken']
      VCR.use_cassette('client/new/token_with_refresh') do
        refute_nil redox(refresh: refresh_token).access_token
      end
    end
  end

  def test_token_bad_keys
    Redox.configure do |r|
      r.api_key = 'bad'
      r.secret = 'keys'
    end
    VCR.use_cassette('client/new/token_invalid_key') do
      assert_raises(Redox::TokenError) do
        redox
      end
    end
  end
end
