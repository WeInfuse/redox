$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox-engine'

require 'minitest/autorun'
require 'minitest/assertions'
require 'webmock/minitest'
require 'test_helper_methods'
require 'vcr'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  # the directory where cassettes will be saved
  c.cassette_library_dir = 'test/vcr'
  c.hook_into :webmock
end

module Minitest
  class Test
    include TestHelpers
  end
end
