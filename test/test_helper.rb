$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'webmock/minitest'
require 'byebug'

Redox.configuration.api_key = '123'
Redox.configuration.secret  = 'abc'

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
