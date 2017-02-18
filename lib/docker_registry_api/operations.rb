module DockerRegistryApi
  # Common operations for the Docker Registry API
  module Operations

    def pull(repo, tag = 'latest')

      img = Image.new(repo: repo, tag: tag)

      execute_request(
        'get',
        @base_uri + "/v2/#{repo}/manifests/#{tag}",
        response_block(File.new("#{img.path}/manifest.mf", 'w+')),
        Accept: response_media_type.manifest
      )

      img.layers.each do |layer|
        next if img.layer_missing(l['digest'])
        execute_request(
          'get',
          @base_uri + "/v2/#{repo}/blobs/#{layer['digest']}",
          response_block(File.new("#{img.path}/#{layer['digest']}", 'w+')),
          Accept: response_media_type.layer
        )
      end
    end

    def response_block(file)
      proc do |response|
        if response.code == '200'
          response.read_body do |chunk|
            file.write chunk
          end
        end
      end
    ensure
      #file.close
    end
  end
end
