require 'json'
require 'net/http'
require 'uri'
require 'openssl'
require 'redox/version'
require 'redox/redox_exception'
require 'redox/authentication'
require 'redox/response'
require 'redox/models/model'
require 'redox/models/meta'
require 'redox/models/patient'
require 'redox/models/demographics'
require 'redox/models/identifiers'

module Redox
  # Redox API client
  class Redox
    DEFAULT_URI = 'https://api.redoxengine.com/'.freeze

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
    def initialize(api_key:, secret:, source: nil, destinations: nil, facility_code: nil, test: true, uri: DEFAULT_URI)
      @api_key = api_key
      @secret = secret
      @meta   = Models::Meta.new
      destinations.each {|dest| @meta.add_destination(dest['Name'], dest['ID']) } if destinations
      @meta.source = source if source
      @meta.facility_code = facility_code if facility_code
      @meta.test   = test
      @connection = nil
      @authentication = nil
      @uri = uri
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
    def add_patient(patient_params, meta = nil)
      meta = @meta.merge(Models::Meta.from_h(Models::Patient::ADD[:meta]).merge(meta))
      body = meta.to_h.merge(Patient: patient_params)

      return request(
        endpoint: Models::Patient::ADD[:endpoint],
        body: body.to_json,
        model: Models::Patient
      )
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
    def update_patient(patient_params, meta = nil)
      meta = @meta.merge(Models::Meta.from_h(Models::Patient::UPDATE[:meta]).merge(meta))
      body = meta.to_h.merge(Patient: patient_params)

      return request(
        endpoint: Models::Patient::UPDATE[:endpoint],
        body: body.to_json,
        model: Models::Patient
      )
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
    def search_patients(patient_params, meta = nil)
      meta = @meta.merge(Models::Meta.from_h(Models::Patient::SEARCH[:meta]).merge(meta))
      body = meta.to_h.merge(Patient: patient_params)

      return request(
        endpoint: Models::Patient::SEARCH[:endpoint],
        body: body.to_json,
        model: Models::Patient
      )
    end

    private

    attr_reader :api_key, :secret, :meta

    def request(endpoint: , body: , header: {}, model: nil, authorize: true)
      header = {
        'Content-Type' => 'application/json'
      }.merge(header)

      header = header.merge(authenticate.access_header) if authorize

      request = Net::HTTP::Post.new(endpoint, header)
      request.body = body

      return Response.new(connection.request(request), model)
    end

    def authenticate
      return @authentication if @authentication

      redox_response = request(
        endpoint: Authentication::ENDPOINT,
        body: { apiKey: api_key, secret: secret }.to_json,
        model: Authentication,
        authorize: false
      )

      if (false == redox_response.success?)
        raise RedoxException.from_response(redox_response.http_response, msg: 'Authentication')
      end

      @authentication = redox_response.model
    end

    def connection
      return @connection if @connection

      uri = URI.parse(@uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5

      @connection = http
    end
  end
end
