# frozen_string_literal: true

module Redox
  class RedoxException < StandardError
    def self.from_response(response, msg: nil)
      exception_msg = "Failed #{msg}:"
      exception_msg << " HTTP code: #{response&.code} MSG: "

      begin
        error_response = response.parsed_response
        error_list = error_response&.[]('Meta')&.[]('Errors')

        exception_msg << if error_list
                           error_list.map { |el| el['Text'] || el.to_s }.join('|')
                         else
                           error_response.to_s
                         end
      rescue JSON::ParserError
        exception_msg << response.body
      end

      RedoxException.new(exception_msg)
    end
  end
end
