# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_registry_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'docker_registry_api'
  spec.version       = DockerRegistryApi::VERSION
  spec.authors       = ['Moritz Heiber']
  spec.email         = ['mheiber@thoughtworks.com']

  spec.summary       = 'A handy interface to the Docker Registry API'
  spec.description   = spec.summary
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'serverspec', '~> 2.38.0'
  spec.add_development_dependency 'docker-api', '~> 1.33.2'
end
