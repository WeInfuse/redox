module Redox
  class LegacyConnection
    DEFAULT_ENDPOINT = '/endpoint'.freeze

    include HTTParty

    base_uri 'https://api.redoxengine.com/'.freeze

    headers 'Content-Type' => 'application/json'

    format :json

    def request(endpoint: DEFAULT_ENDPOINT, body: nil, headers: {}, auth: true)
      body    = body.to_json if body.is_a?(Hash)
      headers = auth_header.merge(headers) if auth

      self.class.post(endpoint, body: body, headers: headers)
    end

    private

    def auth_header
      @auth ||= LegacyAuthentication.new

      @auth.authenticate.access_header
    end
  end
end
