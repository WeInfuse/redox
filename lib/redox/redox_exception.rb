# frozen_string_literal: true

module Redox
  class RedoxException < StandardError
    def self.from_response(response, msg: nil)
      error_msg = nil

      begin
        error_msg = parse_error_msg(response.parsed_response)
      rescue JSON::ParserError
        error_msg = response.body
      end

      RedoxException.new("Failed #{msg}: HTTP code: #{response&.code} MSG: #{error_msg}")
    end

    def self.parse_error_msg(error_response)
      error_list = error_response&.[]('Meta')&.[]('Errors')

      if error_list
        error_list.map { |el| el['Text'] || el.to_s }.join('|')
      else
        error_response.to_s
      end
    end
  end
end
