require 'docker_registry_api/version'
require 'docker_registry_api/operations'
require 'docker_registry_api/util'
require 'docker_registry_api/http'
require 'docker_registry_api/image'

# Main module for the API interface
module DockerRegistryApi
  # The main client class
  class Client
    include Operations
    include Util
    include HTTP

    def initialize(params = {})
      @uri = URI.parse(params.fetch(:uri, 'https://registry.hub.docker.com'))
      @user = params.fetch(:user, nil)
      @password = params.fetch(:password, nil)
      @base_uri = "#{@uri.scheme}://#{@uri.host}:#{@uri.port}"
    end
  end
end
