require 'redox/version'
require 'redox/client'
require 'core_ext/hash'
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

  class TokenError < StandardError; end
end
