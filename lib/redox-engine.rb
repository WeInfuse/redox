require 'core_ext/hash'
require 'redox-engine/version'
require 'redox-engine/util'
require 'redox-engine/request_helpers'
require 'redox-engine/exceptions'
require 'redox-engine/client'
require 'redox-engine/patient'
require 'redox-engine/visit'
require 'json'
require 'net/http'
require 'uri'

# a set of Ruby classes for RedoxEngine HTTP API interactions
module RedoxEngine
  API_URL = URI.parse('https://api.redoxengine.com/')
  class << self
    attr_accessor :api_key, :secret
  end

  def self.configure
    yield self
    true
  end
end
