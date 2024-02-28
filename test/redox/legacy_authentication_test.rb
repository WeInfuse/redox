require 'test_helper'

class LegacyAuthenticationTest < Minitest::Test
  describe 'legacy_authentication' do
    before do
      legacy_stub_redox(body: {})

      # stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Authentication::AUTH_ENDPOINT))
        # .with(body: { apiKey: 'wrong', secret: 'abc' })
        # .to_return(status: 401, body: 'Invalid request')

      @redox_auth = Redox::LegacyAuthentication.new
      @config = Redox.configuration.to_h
    end

    after do
      Redox.configuration.from_h(@config)
      Redox::LegacyAuthentication.token_expiry_padding = nil
    end

    describe 'configuration' do
      it 'can set the expiry padding to 0' do
        Redox::LegacyAuthentication.token_expiry_padding = 0
        assert_equal(0, Redox::LegacyAuthentication.token_expiry_padding)
      end
    end

    describe 'authentication' do
      it 'calls redox endpoint' do
        @redox_auth.authenticate
        assert_requested(@legacy_auth_stub, times: 1)
      end

      it 'makes no calls when token wont expire inside padding time' do
        Redox::LegacyAuthentication.token_expiry_padding = -60

        @redox_auth.authenticate
        @redox_auth.authenticate

        assert_requested(@legacy_auth_stub, times: 1)

        assert_equal('let.me.in', @redox_auth.access_token)
      end

      it 'fails with a reasonable exception and with nil response' do
        @redox_auth.expire!

        @auth_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::LegacyAuthentication::AUTH_ENDPOINT))
                       .to_return(status: 401, body: 'Invalid request' )

        error = assert_raises(Redox::RedoxException) { @redox_auth.authenticate }

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
        assert(@redox_auth.expires?(300))
      end

      it 'is false when token is far enough from expire' do
        assert(false == @redox_auth.expires?(0))
      end

      it 'uses the default' do
        Redox::LegacyAuthentication.token_expiry_padding = 9999

        assert(@redox_auth.expires?)
      end
    end
  end
end
