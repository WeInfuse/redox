module Redox
  # Exceptions used in this gem will be defined here

  # raise this on errors obtaining an access token
  class TokenError < StandardError; end

  # raise this on Redox::Client.new without setting api_key/secret
  class APIKeyError < StandardError; end
end
