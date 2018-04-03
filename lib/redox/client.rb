module Redox
  # Redox API client
  class Client
    attr_reader :source, :destinations, :test, :access_token, :refresh_token
    # Instantiates a new Redox connection object
    #
    # @param [Hash] source source information
    # @param [Array<Hash>] destinations list of destinations
    # @param [Boolean] test whether to use test mode
    # @param [String] Optional param to provide an existing Access Token
    # @param [String] Optional param to provide an existing Refresh Token
    # @example
    #   redox = Redox::Client.new(
    #     source: source,
    #     destinations: destinations,
    #     test: true,
    #     OPTIONAL: (If tokens/refresh_tokens are being persisted elsewhere)
    #     token: (existing access token),
    #     refresh_token: (existing refresh token)
    #   )
    def initialize(
      source:, destinations:, test: true, token: nil, refresh_token: nil
    )
      @refresh_token = refresh_token
      @access_token = token || fetch_access_token

      @source = source
      @destinations = destinations
      @test = test
    end

    # Send NewPatient message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   Redox::Redox.new(*connection_params).add_patient(
    #     Identifiers: [],
    #     Demographics: {
    #       FirstName: 'Joe'
    #     }
    #   )
    def add_patient(patient_params)
      patient_request = Net::HTTP::Post.new('/endpoint', auth_header)
      request_body = request_meta(
        data_model: 'PatientAdmin', event_type: 'NewPatient'
      ).merge(Patient: patient_params)
      patient_request.body = request_body.to_json
      response = connection.request(patient_request)

      JSON.parse(response.body)
    end

    private

    def fetch_access_token
      return @access_token if @access_token

      response = connection.request(login_request(@refresh_token))
      code = response.code.to_i
      raise TokenError, 'Error obtaining token' unless code >= 200 && code < 400
      body = JSON.parse(response.body)
      @refresh_token = body['refreshToken']

      body['accessToken']
    end

    def connection
      return @connection if @connection

      http = Net::HTTP.new(API_URL.host, API_URL.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5

      @connection = http
    end

    def auth_header
      {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      }
    end

    def request_meta(data_model:, event_type:)
      {
        Meta: {
          DataModel: data_model,
          EventType: event_type,
          EventDateTime: Time.now.to_json,
          Test: @test,
          Source: @source,
          Destinations: @destinations
        }
      }
    end

    def login_request(refresh_token = nil)
      req_url = refresh_token ? '/auth/refreshToken' : '/auth/authenticate'
      req = Net::HTTP::Post.new(req_url, 'Content-Type' => 'application/json')
      req_body = { apiKey: Redox.api_key }
      if refresh_token
        req_body[:refreshToken] = refresh_token
      else
        req_body[:secret] = Redox.secret
      end
      req.body = req_body.to_json
      req
    end
  end
end
