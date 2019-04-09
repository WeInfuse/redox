module Redox
  class RedoxException < Exception
    def self.from_response(response, msg: nil)
      exception_msg = "Failed #{msg}:"
      exception_msg << " HTTP code: #{response.code} MSG: "

      begin
        error_response = JSON.parse(response.body)

        if (error_response.is_a?(Hash) && error_response.include?("Meta") && error_response["Meta"].include?("Errors"))
          exception_msg << error_response["Meta"]["Errors"]
        else
          exception_msg << error_response
        end
      rescue JSON::ParserError
        exception_msg << response.body
      end

      return RedoxException.new(exception_msg)
    end
  end
end
