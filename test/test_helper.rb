$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'webmock/minitest'

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
