# frozen_string_literal: true

require 'base64'
require 'httparty'
require 'hashie'
require 'redox/version'
require 'redox/redox_exception'
require 'redox/connection'
require 'redox/authentication'
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
    attr_accessor :api_key, :secret

    def initialize
      @api_key  =  nil
      @secret   =  nil
    end

    def api_endpoint=(endpoint)
      Connection.base_uri(endpoint.freeze)
    end

    def api_endpoint
      Connection.base_uri
    end

    def token_expiry_padding=(time_in_seconds)
      Authentication.token_expiry_padding = time_in_seconds
    end

    def token_expiry_padding
      Authentication.token_expiry_padding
    end

    def to_h
      {
        api_key: @api_key,
        secret: @secret,
        api_endpoint: api_endpoint,
        token_expiry_padding: token_expiry_padding
      }
    end

    def from_h(init_hash)
      self.api_key = init_hash[:api_key]
      self.secret  = init_hash[:secret]
      self.api_endpoint = init_hash[:api_endpoint]
      self.token_expiry_padding = init_hash[:token_expiry_padding]

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
