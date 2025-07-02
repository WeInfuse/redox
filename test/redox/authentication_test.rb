require 'test_helper'

class AuthenticationTest < Minitest::Test
  describe 'authentication' do
    before do
      auth_stub
      refresh_stub

      stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Authentication::AUTH_ENDPOINT))
        .with(body: { apiKey: 'wrong', secret: 'abc' })
        .to_return(status: 401, body: 'Invalid request')

      @redox_auth = Redox::Authentication.new
      @config = Redox.configuration.to_h
    end

    after do
      Redox.configuration.from_h(@config)
    end

    describe 'configuration' do
      it 'can set the expiry padding to 0' do
        Redox::Authentication.token_expiry_padding = 0

        assert_equal(0, Redox::Authentication.token_expiry_padding)
      end
    end

    describe 'authentication' do
      it 'calls redox endpoint' do
        @redox_auth.authenticate

        assert_requested(@auth_stub, times: 1)
      end

      it 'uses refresh endpoint if we already have a token' do
        Redox::Authentication.token_expiry_padding = 9999

        @redox_auth.authenticate
        @redox_auth.authenticate

        assert_requested(@auth_stub, times: 1)
        assert_requested(@refresh_stub, times: 1)

        assert_equal('let.me.in.again', @redox_auth.access_token)
      end

      it 'makes no calls when token wont expire inside padding time' do
        Redox::Authentication.token_expiry_padding = -60

        @redox_auth.authenticate
        @redox_auth.authenticate

        assert_requested(@auth_stub, times: 1)
        assert_requested(@refresh_stub, times: 0)

        assert_equal('let.me.in', @redox_auth.access_token)
      end

      it 'fails with a resonable exception and with nil response' do
        @redox_auth.expire!

        key = Redox.configuration.api_key
        Redox.configuration.api_key = 'wrong'

        error = assert_raises(Redox::RedoxException) { @redox_auth.authenticate }

        Redox.configuration.api_key = key

        assert_match(/Failed Authenticat/, error.message)
        assert_match(/HTTP code: 401/, error.message)
        assert_match(/MSG: Invalid request/, error.message)
        assert_nil(@redox_auth.response)
      end
    end

    describe 'responses' do
      before do
        @redox_auth.authenticate
      end

      it 'has an access token' do
        assert_equal('let.me.in', @redox_auth.access_token)
      end

      it 'can create the auth header' do
        assert_equal('let.me.in', @redox_auth.access_token)
      end
    end

    describe '#expires?' do
      before do
        @redox_auth.authenticate
      end

      it 'is true when token is too close to expire padding' do
        assert(@redox_auth.expires?(60))
      end

      it 'is false when token is far enough from expire' do
        assert_equal(false, @redox_auth.expires?(0))
      end

      it 'uses the default' do
        Redox::Authentication.token_expiry_padding = 9999

        assert_predicate(@redox_auth, :expires?)
      end
    end

    after do
      Redox::Authentication.token_expiry_padding = nil
    end
  end
end
