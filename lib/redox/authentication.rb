# frozen_string_literal: true

module Redox
  class Authentication < Connection
    attr_accessor :response

    BASE_ENDPOINT    = '/auth'

    AUTH_ENDPOINT    = "#{BASE_ENDPOINT}/authenticate"
    REFRESH_ENDPOINT = "#{BASE_ENDPOINT}/refreshToken"

    class << self
      attr_accessor :token_expiry_padding

      @@token_expiry_padding = 0
    end

    def initialize
      @response = nil
    end

    def authenticate
      if expires?
        request = if refresh_token
                    {
                      body: { apiKey: Redox.configuration.api_key, refreshToken: refresh_token },
                      endpoint: REFRESH_ENDPOINT
                    }
                  else
                    {
                      body: { apiKey: Redox.configuration.api_key, secret: Redox.configuration.secret },
                      endpoint: AUTH_ENDPOINT
                    }
                  end

        response = self.request(**request, auth: false)

        if false == response.ok?
          @response = nil
          raise RedoxException.from_response(response, msg: 'Authentication')
        else
          @response = response
        end
      end

      self
    end

    def access_token
      @response['accessToken'] if @response
    end

    def expiry
      @response['expires'] if @response
    end

    def refresh_token
      @response['refreshToken'] if @response
    end

    def expires?(seconds_from_now = Authentication.token_expiry_padding)
      if expiry
        DateTime.strptime(expiry,
                          Models::Meta::FROM_DATETIME_FORMAT).to_time.utc <= (Time.now + seconds_from_now).utc
      else
        true
      end
    end

    def access_header
      {
        'Authorization' => "Bearer #{access_token}"
      }
    end

    def expire!
      @response = nil
    end
  end
end
