module Redox
  class Connection
    DEFAULT_ENDPOINT = '/endpoint'.freeze

    include HTTParty

    base_uri 'https://api.redoxengine.com/'.freeze

    headers 'Content-Type' => 'application/json'

    format :json

    def post(endpoint: DEFAULT_ENDPOINT, body: nil, headers: {}, auth: true)
      body    = body.to_json if body.is_a?(Hash)
      headers = auth_header(auth_class(endpoint)).merge(headers) if auth

      self.class.post(endpoint, body: body, headers: headers)
    end
    alias :request :post

    def get(endpoint:, headers: {}, auth: true)
      headers = auth_header(auth_class(endpoint)).merge(headers) if auth

      self.class.get(endpoint, headers: headers)
    end

    private

    def auth_class(endpoint)
      endpoint.start_with?('/platform') ? PlatformAuthentication : FHIRAuthentication
    end

    def auth_header(klass)
      @auth ||= klass.new

      @auth.authenticate.access_header
    end
  end
end
