# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redox/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.0.7'

  spec.name          = 'redox'
  spec.version       = Redox::VERSION
  spec.authors       = ['Alexander Clark', 'Mike Crockett', 'Mike Carr']
  spec.email         = ['alexander.clark@weinfuse.com', 'mike.crockett@weinfuse.com', 'michael.carr@weinfuse.com']

  spec.summary       = 'Ruby wrapper for the Redox Engine API'
  spec.homepage      = 'https://github.com/WeInfuse/redox'

  # Prevent pushing this gem to RubyGems.org.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    spec.metadata['rubygems_mfa_required'] = 'true'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match?(%r{^(test|spec|features|bin|helpers|)/}) || f.match?(/^(\.[[:alnum:]]+)/)
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.licenses      = ['MIT']

  spec.add_dependency 'hashie', '~> 3.5'
  spec.add_dependency 'httparty', '~> 0.21'
end
