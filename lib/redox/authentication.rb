module Redox
  class Authentication
    ENDPOINT = '/auth/authenticate'.freeze

    def initialize(response_body)
      @body = response_body
    end

    def access_token
      return @body['accessToken']
    end

    def access_header
      return {
        'Authorization' => "Bearer #{access_token}",
      }
    end
  end
end
