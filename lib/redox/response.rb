module Redox
  class Response
    attr_reader :model, :http_response

    def initialize(response, model_class = nil)
      @http_response = response
      @model    = model_class.new(JSON.parse(response.body)) if !model_class.nil? && self.success?
    end

    def success?
      return @http_response.is_a?(Net::HTTPOK)
    end
  end
end
