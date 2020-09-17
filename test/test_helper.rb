$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'webmock/minitest'
require 'byebug'

Redox.configuration.api_key = '123'
Redox.configuration.secret  = 'abc'

# HTTParty has added a really annoying deprecation warning in 0.18.1
#  that flags even though we aren't using the method and is using
#  the Kernel.warn method. Turning it off for test environment
module HTTParty
  class Response < Object
    private

    def warn_about_nil_deprecation
    end
  end
end

def patient_admin_responses(event_type = :patient_update, parse: true)
  if (:patient_update == event_type)
    return load_sample('patient_search_single_result.response.json', parse: parse)
  else
    return load_sample("#{event_type}.response.json", parse: true)
  end
end

def load_sample(file, parse: false)
  file = File.join('test', 'samples', file)
  file_contents = nil

  if (false == File.exist?(file))
    raise "Can't find file '#{file}'."
  end

  file_contents = File.read(file)

  if (true == parse)
    if (true == file.end_with?('.json'))
      return JSON.parse(file_contents)
    end
  end

  return file_contents
end

def stub_redox(status: 200, body: , endpoint: Redox::Connection::DEFAULT_ENDPOINT )
  body = body.to_json if body.is_a?(Hash)

  stub_request(:post, /#{Redox::Authentication::BASE_ENDPOINT}/)
    .with(body: hash_including({ apiKey: '123'}))
    .to_return(status: 200, body: { accessToken: 'let.me.in' }.to_json )

  @post_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
    .with(headers: { 'Authorization' => 'Bearer let.me.in' })
    .to_return(status: 200, body: body)
end

def auth_stub
  @auth_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Authentication::AUTH_ENDPOINT))
    .with(body: { apiKey: '123', secret: 'abc' })
    .to_return(status: 200, body: { accessToken: 'let.me.in', expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), refreshToken: 'rtoken' }.to_json )
end

def refresh_stub
  @refresh_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Authentication::REFRESH_ENDPOINT))
    .with(body: { apiKey: '123', refreshToken: 'rtoken' })
    .to_return(status: 200, body: { accessToken: 'let.me.in.again', expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT), refreshToken: 'rtoken' }.to_json )
end
