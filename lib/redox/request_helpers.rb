module Redox
  # module to abstract request helper methods out of the client class
  module RequestHelpers
    private

    def handle_request(request_body, error_message)
      request = Net::HTTP::Post.new('/endpoint', auth_header)
      request.body = request_body.to_json
      @response = connection.request(request)
      body = JSON.parse(response.body).rubyize_keys
      if @response.code == '400'
        $stdout.print error_message
        return body[:meta]
      end

      body
    end

    def auth_header
      {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      }
    end

    def request_meta(data_model:, event_type:)
      {
        meta: {
          data_model: data_model,
          event_type: event_type,
          event_date_time: Time.now.iso8601,
          test: @test,
          source: @source,
          destinations: find_destination(data_model)
        }
      }.redoxify_keys
    end

    def scheduling_query(visit:, start_time: nil, end_time: nil)
      start_time = start_time ? Time.parse(start_time.to_s) : Time.now
      end_time = end_time ? Time.parse(end_time.to_s) : start_time + 864_000
      request_meta(data_model: 'Scheduling', event_type: 'Booked')
        .merge(
          visit: visit,
          start_date_time: start_time.iso8601,
          end_date_time: end_time.iso8601
        )
        .redoxify_keys
    end

    def login_request(refresh_token = nil)
      req_url = refresh_token ? '/auth/refreshToken' : '/auth/authenticate'
      req = Net::HTTP::Post.new(req_url, 'Content-Type' => 'application/json')
      req_body = { apiKey: Redox.api_key }
      if refresh_token
        req_body[:refreshToken] = refresh_token
      else
        req_body[:secret] = Redox.secret
      end
      req.body = req_body.to_json
      req
    end

    def fetch_access_token
      return @access_token if defined? @access_token

      response = connection.request(login_request(@refresh_token))
      code = response.code.to_i
      raise TokenError, 'Error obtaining token' unless code >= 200 && code < 400
      body = JSON.parse(response.body)
      @refresh_token = body['refreshToken']

      body['accessToken']
    end

    def connection
      return @connection if defined? @connection

      http = Net::HTTP.new(API_URL.host, API_URL.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5

      @connection = http
    end

    def find_destination(destination_name)
      [@destinations[destination_name.split(' ').join.to_sym]]
    end
  end
end
