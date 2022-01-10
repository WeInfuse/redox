module Redox
  class RedoxException < Exception
    def self.from_response(response, msg: nil)
      exception_msg = "Failed #{msg}:"
      exception_msg << " HTTP code: #{response&.code} MSG: "

      begin
        error_response = response.parsed_response
        error_list = error_response&.[]('Meta')&.[]('Errors')

        if error_list
          exception_msg << error_list.map {|el| el['Text'] || el.to_s }.join('|')
        else
          exception_msg << error_response.to_s
        end
      rescue JSON::ParserError
        exception_msg << response.body
      end

      return RedoxException.new(exception_msg)
    end
  end
end
