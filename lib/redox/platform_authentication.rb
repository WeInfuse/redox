module Redox
  class PlatformAuthentication < Connection
    include Authentication

    class << self
      attr_accessor :token_expiry_padding

      @@token_expiry_padding = 0
    end

    def initialize
      @client_id = Redox.configuration.platform_client_id
      @private_key = Redox.configuration.platform_private_key
    end
  end
end
