$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'webmock/minitest'

def load_sample(file)
  sample_file = File.join('test', 'samples', file)

  if (false == File.exist?(sample_file))
    raise "Can't find file '#{sample_file}'."
  end

  return File.read(sample_file)
end
