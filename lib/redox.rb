require 'httparty'
require 'hashie'
require 'redox/version'
require 'redox/redox_exception'
require 'redox/connection'
require 'redox/authentication'
require 'redox/models/model'
require 'redox/models/meta'
require 'redox/models/patient'
require 'redox/models/visit'
require 'redox/models/transaction'
require 'redox/models/financial'
require 'redox/models/patient/demographics'
require 'redox/models/patient/identifier'
require 'redox/models/patient/insurance'
require 'redox/models/patient/p_c_p'
require 'redox/models/potential_matches'
require 'redox/request/request'
require 'redox/request/financial'
require 'redox/request/patient_admin'
require 'redox/request/patient_search'

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
      return Connection.base_uri
    end

    def token_expiry_padding=(time_in_seconds)
      Authentication.token_expiry_padding = time_in_seconds
    end

    def token_expiry_padding
      return Authentication.token_expiry_padding
    end

    def to_h
      return {
        api_key: @api_key,
        secret: @secret,
        api_endpoint: api_endpoint,
        token_expiry_padding: token_expiry_padding
      }
    end

    def from_h(h)
      self.api_key = h[:api_key]
      self.secret  = h[:secret]
      self.api_endpoint = h[:api_endpoint]
      self.token_expiry_padding = h[:token_expiry_padding]

      return self
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
