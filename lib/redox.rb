require 'core_ext/hash'
require 'redox/version'
require 'redox/util'
require 'redox/request_helpers'
require 'redox/exceptions'
require 'redox/client'
require 'redox/patient'
require 'redox/visit'
require 'json'
require 'net/http'
require 'uri'

# a set of Ruby classes for Redox HTTP API interactions
module Redox
  API_URL = URI.parse('https://api.redoxengine.com/')
  class << self
    attr_accessor :api_key, :secret
  end

  def self.configure
    yield self
    true
  end
end
