require 'redox/version'
require 'json'
require 'net/http'
require 'uri'

module Redox
  # Redox API client
  class Redox
    # Instantiates a new Redox connection object
    #
    # @param [String] api_key API key for the connection
    # @param [String] secret API secret for the connection
    # @param [Hash] source source information
    # @param [Array<Hash>] destinations list of destinations
    # @param [Boolean] test whether to use test mode
    # @example
    #   redox = Redox::Redox.new(
    #     api_key: ENV['REDOX_KEY'],
    #     secret: ENV['REDOX_SECRET'],
    #     source: source,
    #     destinations: destinations,
    #     test: true
    #   )
    def initialize(api_key:, secret:, source:, destinations:, test: true)
      @api_key = api_key
      @secret = secret
      @source = source
      @destinations = destinations
      @test = test
    end

    # Send PatientUpdate message
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
        data_model: 'PatientAdmin', event_type: 'PatientUpdate'
      ).merge(Patient: patient_params)
      patient_request.body = request_body.to_json

      response = connection.request(patient_request)

      JSON.parse(response.body)
    end

    private

    attr_reader :api_key, :secret, :source, :destinations, :test

    def access_token
      return @access_token if @access_token

      login_request = Net::HTTP::Post.new(
        '/auth/authenticate', 'Content-Type' => 'application/json'
      )
      login_request.body = { apiKey: api_key, secret: secret }.to_json
      response = connection.request(login_request)
      body = JSON.parse(response.body)

      @access_token = body['accessToken']
    end

    def connection
      return @connection if @connection

      uri = URI.parse('https://api.redoxengine.com/')
      http = Net::HTTP.new(uri.host, uri.port)
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
          Test: test,
          Source: source,
          Destinations: destinations
        }
      }
    end
  end
end
