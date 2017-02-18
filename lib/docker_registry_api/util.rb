module DockerRegistryApi
  # Class for common utility
  module Util
    def response_media_type
      @response_media_type ||= OpenStruct.new(
        manifest: 'application/vnd.docker.distribution.manifest.v2+json',
        layer: 'application/vnd.docker.image.rootfs.diff.tar.gzip'
      )
    end
  end
end
