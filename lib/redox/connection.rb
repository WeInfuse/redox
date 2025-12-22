# frozen_string_literal: true

module Redox
  class Connection
    DEFAULT_ENDPOINT = '/endpoint'

    include HTTParty

    base_uri 'https://api.redoxengine.com/'

    headers 'Content-Type' => 'application/json'

    format :json

    def request(endpoint: DEFAULT_ENDPOINT, body: nil, headers: {}, auth: true)
      body    = body.as_json.to_json if body.is_a?(Hash)
      headers = auth_header.merge(headers) if auth

      self.class.post(endpoint, body: body, headers: headers)
    end

    private

    def auth_header
      @auth ||= Authentication.new

      @auth.authenticate.access_header
    end
  end
end
