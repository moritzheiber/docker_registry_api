require 'docker_registry_api/http'
require 'docker_registry_api/util'
require 'json'

module DockerRegistryApi
  # A class representation of an image
  class Image
    attr_reader :path
    attr_reader :layers
    attr_reader :manifest
    attr_reader :manifest_path

    def initialize(params = {})
      @repo = params.fetch(:repo)
      @tag = params.fetch(:tag)
      @dir = params.fetch(:dir, default_dir)
      @path = "#{@dir}/#{@repo}/#{@tag}"

      FileUtils.mkdir_p(@path)
    end

    def exists?
      !missing_layers?
    end

    def manifest_path
      "#{@path}/manifest.mf"
    end

    def layer_path(digest)
      "#{@path}/#{digest}"
    end

    def manifest
      @manifest ||= JSON.parse(IO.read(manifest_path))
    end

    def layers
      @layers ||= manifest['layers']
    end

    def manifest_missing
      File.file?(manifest_path)
    end

    def layer_missing(digest)
      File.file?(layer_path(digest))
    end

    private

    def default_dir
      @default_dir ||= Dir.pwd + '/images'
    end

    def missing_layers?
      layers.each do |l|
        return true unless layer_missing(l['digest'])
      end
      false
    end
  end
end
