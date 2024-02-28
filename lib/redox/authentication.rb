require 'json/jwt'
require 'jwt'

module Redox
  module Authentication
    attr_reader :client_id, :environment, :private_key, :response

    AUTH_URL = 'https://api.redoxengine.com/v2/auth/token'

    BASE_ENDPOINT = '/v2/auth'.freeze
    AUTH_ENDPOINT = "#{BASE_ENDPOINT}/token".freeze
    REFRESH_ENDPOINT = "#{BASE_ENDPOINT}/refreshToken".freeze

    def authenticate
      return self unless expired?

      jwt_token = generate_jwt
      payload = {
        body: {
          grant_type: 'client_credentials',
          client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
          client_assertion: jwt_token
        }
      }
      @last_auth_time = Time.now.utc
      response = HTTParty.post(AUTH_URL, payload)

      if response.ok?
        @response = JSON.parse(response.body)
      else
        @response = nil
        raise RedoxException.from_response(response, msg: 'Authentication')
      end

      self
    end

    def access_header
      { 'Authorization' => "Bearer #{access_token}" }
    end

    def access_token
      @response['access_token'] if @response
    end

    def expired?
      return true unless @response

      @last_auth_time + @response['expires_in'].to_i < (Time.now + self.class.token_expiry_padding).utc
    end

    def expires?(seconds_from_now = self.class.token_expiry_padding)
      return true unless @response

      @last_auth_time + @response['expires_in'].to_i < (Time.now + seconds_from_now).utc
    end

    def expire!
      @response = nil
    end

    private

    def generate_jwt(audience = AUTH_URL)
      private_key = extract_private_key
      kid_value = extract_or_generate_kid(private_key)

      payload = {
        iss: client_id,
        sub: client_id,
        aud: audience,
        exp: 5.minutes.from_now.to_i,
        iat: Time.now.to_i,
        jti: SecureRandom.uuid
      }

      # Use private_key directly if it's an instance of OpenSSL::PKey::RSA
      key_for_jwt = private_key.is_a?(OpenSSL::PKey::RSA) ? private_key : private_key.to_key
      headers = { kid: kid_value, alg: 'RS384' }

      # Sign the JWT with the appropriate private key and RS384 algorithm that Redox supports
      JWT.encode(payload, key_for_jwt, 'RS384', headers)
    end

    # Parse either the jwk or pem value depending on availability
    def extract_private_key
      if private_key.is_a?(String) && valid_json?(private_key)
        JSON::JWK.new(JSON.parse(private_key))
      elsif private_key.is_a?(String)
        OpenSSL::PKey::RSA.new(private_key)
      else
        raise 'Invalid private key format. Expected JSON or PEM string.'
      end
    end

    def extract_or_generate_kid(key)
      if key.is_a?(JSON::JWK)
        key[:kid]
      elsif key.is_a?(OpenSSL::PKey::RSA)
        digest = OpenSSL::Digest.new('SHA256')
        Base64.urlsafe_encode64(digest.digest(key.to_der)).strip
      else
        raise 'Unsupported key type for generating kid.'
      end
    end

    def valid_json?(json)
      return false if json.nil?

      JSON.parse(json)
      true
    rescue JSON::ParserError
      false
    end
  end
end
