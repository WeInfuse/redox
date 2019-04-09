require 'json'
require 'net/http'
require 'uri'
require 'openssl'
require 'redox/version'
require 'redox/redox_exception'
require 'redox/models/model'
require 'redox/models/patient'
require 'redox/models/demographics'
require 'redox/models/identifiers'

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
    def initialize(api_key:, secret:, source:, destinations:, facility_code: nil, test: true)
      @api_key = api_key
      @secret = secret
      @source = source
      @destinations = destinations
      @facility_code = facility_code
      @test = test
      @connection = nil
      @access_token = nil
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

    # Send PatientUpdate message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   Redox::Redox.new(*connection_params).update_patient(
    #     Identifiers: [],
    #     Demographics: {
    #       FirstName: 'Joe'
    #     }
    #   )
    def update_patient(patient_params)
      patient_request = Net::HTTP::Post.new('/endpoint', auth_header)
      request_body = request_meta(
        data_model: 'PatientAdmin', event_type: 'PatientUpdate'
      ).merge(Patient: patient_params)
      patient_request.body = request_body.to_json

      response = connection.request(patient_request)

      JSON.parse(response.body)
    end

    # Send PatientSearch query
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] Redox Patient object
    # @example
    #   Redox::Redox.new(*connection_params).search_patients(
    #     Identifiers: [],
    #     Demographics: {
    #       FirstName: 'Joe'
    #     }
    #   )
    def search_patients(patient_params)
      patient_request = Net::HTTP::Post.new(Models::Patient::SEARCH[:endpoint], auth_header)
      request_body = request_meta(Models::Patient::SEARCH[:meta])
        .merge(Patient: patient_params)
      patient_request.body = request_body.to_json

      response = connection.request(patient_request)

      return Models::Patient.new(JSON.parse(response.body))
    end

    private

    attr_reader :api_key, :secret, :source, :destinations, :facility_code, :test

    def access_token
      return @access_token if @access_token

      login_request = Net::HTTP::Post.new(
        '/auth/authenticate', 'Content-Type' => 'application/json'
      )
      login_request.body = { apiKey: api_key, secret: secret }.to_json
      response = connection.request(login_request)

      if (false == response.is_a?(Net::HTTPOK))
        raise RedoxException.from_response(response, msg: 'Authentication')
      end

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
      meta_object = {
        Meta: {
          DataModel: data_model,
          EventType: event_type,
          EventDateTime: nil,
          Test: test,
        }
      }

      meta_object[:Meta][:FacilityCode] = facility_code if facility_code
      meta_object[:Meta][:Source] = source if source
      meta_object[:Meta][:Destinations] = destinations if destinations && !destinations.empty?

      meta_object
    end
  end
end
