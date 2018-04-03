$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'minitest/assertions'
require 'webmock/minitest'
require 'vcr'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  # the directory where cassettes will be saved
  c.cassette_library_dir = 'test/vcr'
  c.hook_into :webmock
end

module TestHelpers
  def redox_keys
    file = File.open(File.join(__dir__, 'redox_keys.yml'))
    return YAML.safe_load(file).symbolize_keys if file
    raise StandardError, 'Keys not found. Please save real redox keys in \
    test/redox_keys.yml to run tests'
  end
end

module Minitest
  class Test
    include TestHelpers
  end
end
