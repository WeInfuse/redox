lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redox/version'

Gem::Specification.new do |spec|
  spec.name          = 'redox'
  spec.version       = Redox::VERSION
  spec.authors       = ['Alexander Clark', 'Pedro De Ona']
  spec.email         = ['sasha.jackal@gmail.com', 'p.deona2005@gmail.com']
  spec.licenses      = ['MIT']
  spec.summary       = 'Ruby wrapper for the Redox Engine API'
  spec.homepage      = 'https://github.com/WeInfuse/redox'

  # Prevent pushing this gem to RubyGems.org.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.5'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.1'
  spec.add_development_dependency 'yard', '~> 0.9'
end
