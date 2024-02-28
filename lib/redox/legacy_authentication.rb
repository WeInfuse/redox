module Redox
  class LegacyAuthentication < LegacyConnection
    attr_accessor :response

    BASE_ENDPOINT    = '/auth'.freeze

    AUTH_ENDPOINT    = "#{BASE_ENDPOINT}/authenticate".freeze
    REFRESH_ENDPOINT = "#{BASE_ENDPOINT}/refreshToken".freeze

    class << self
      attr_accessor :token_expiry_padding

      @@token_expiry_padding = 0
    end

    def initialize
      @response = nil
    end

    def authenticate
      if (self.expires?)
        if (self.refresh_token)
          request = {
            body: { apiKey: Redox.configuration.api_key, refreshToken: self.refresh_token },
            endpoint: REFRESH_ENDPOINT
          }
        else
          request = {
            body: { apiKey: Redox.configuration.api_key, secret: Redox.configuration.secret },
            endpoint: AUTH_ENDPOINT
          }
        end

        response = self.request(**request, auth: false)

        if (false == response.ok?)
          @response = nil
          raise RedoxException.from_response(response, msg: 'Authentication')
        else
          @response = response
        end
      end

      return self
    end

    def access_token
      return @response['accessToken'] if @response
    end

    def expiry
      return @response['expires'] if @response
    end

    def refresh_token
      return @response['refreshToken'] if @response
    end

    def expires?(seconds_from_now = LegacyAuthentication.token_expiry_padding)
      if (self.expiry)
        return DateTime.strptime(self.expiry, Models::Meta::FROM_DATETIME_FORMAT).to_time.utc <= (Time.now + seconds_from_now).utc
      else
        return true
      end
    end

    def access_header
      return {
        'Authorization' => "Bearer #{self.access_token}",
      }
    end

    def expire!
      @response = nil
    end
  end
end
