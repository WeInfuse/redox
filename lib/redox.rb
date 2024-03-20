require 'httparty'
require 'hashie'
require 'redox/version'
require 'redox/redox_exception'
require 'redox/connection'
require 'redox/legacy_connection'
require 'redox/authentication'
require 'redox/fhir_authentication'
require 'redox/legacy_authentication'
require 'redox/platform_authentication'
require 'redox/models/model'
require 'redox/models/meta'
require 'redox/models/ordering_provider'
require 'redox/models/patient'
require 'redox/models/provider'
require 'redox/models/visit'
require 'redox/models/transaction'
require 'redox/models/financial'
require 'redox/models/notes'
require 'redox/models/note'
require 'redox/models/media'
require 'redox/models/media/notification'
require 'redox/models/media_upload'
require 'redox/models/medication'
require 'redox/models/medications'
require 'redox/models/administration'
require 'redox/models/patient/demographics'
require 'redox/models/patient/contacts'
require 'redox/models/patient/identifier'
require 'redox/models/patient/insurance'
require 'redox/models/patient/p_c_p'
require 'redox/models/potential_matches'
require 'redox/models/scheduling'
require 'redox/models/component'
require 'redox/request/request'
require 'redox/request/financial'
require 'redox/request/notes'
require 'redox/request/patient_admin'
require 'redox/request/patient_search'
require 'redox/request/provider'
require 'redox/request/scheduling'
require 'redox/request/media'
require 'redox/request/medications'

module Redox
  class Configuration
    attr_accessor :api_key, :secret, :fhir_client_id, :fhir_private_key, :platform_client_id, :platform_private_key

    def initialize
      # legacy
      @api_key = nil
      @secret = nil

      # oauth
      @fhir_client_id =  nil
      @fhir_private_key =  nil
      @platform_client_id = nil
      @platform_private_key = nil
    end

    def api_endpoint=(endpoint)
      Connection.base_uri(endpoint.freeze)
    end

    def api_endpoint
      Connection.base_uri
    end

    def token_expiry_padding=(time_in_seconds)
      FHIRAuthentication.token_expiry_padding = time_in_seconds
    end

    def token_expiry_padding
      FHIRAuthentication.token_expiry_padding
    end

    def to_h
      {
        api_key: @api_key,
        secret: @secret,
        fhir_client_id: @fhir_client_id,
        fhir_private_key: @fhir_private_key,
        platform_client_id: @platform_client_id,
        platform_private_key: @platform_private_key,
        api_endpoint: api_endpoint,
        token_expiry_padding: token_expiry_padding
      }
    end

    def from_h(h)
      self.api_key = h[:api_key]
      self.secret = h[:secret]

      self.fhir_client_id = h[:fhir_client_id]
      self.fhir_private_key = h[:fhir_private_key]
      self.platform_client_id = h[:platform_client_id]
      self.platform_private_key = h[:platform_private_key]
      self.api_endpoint = h[:api_endpoint]
      self.token_expiry_padding = h[:token_expiry_padding]

      self
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  # Redox API client
  class RedoxClient
    class << self
      def connection
        Redox.configuration.token_expiry_padding = 60 if Redox.configuration.token_expiry_padding.nil?
        @connection ||= Connection.new
      end

      def release
        @connection = nil
      end
    end
  end
end
