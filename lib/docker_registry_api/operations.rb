module DockerRegistryApi
  # Common operations for the Docker Registry API
  module Operations

    def layer_exists(repo, digest)
      response = execute_request(
        'head',
        @base_uri + "/v2/#{repo}/blobs/#{digest}"
      )
      return response.code == '200'
    end

    def pull(repo, tag = 'latest')

      img = Image.new(repo: repo, tag: tag)
      
      manifest_file = File.new(img.manifest_path, 'w+')
      execute_request(
        'get',
        @base_uri + "/v2/#{repo}/manifests/#{tag}",
        response_block(manifest_file),
        Accept: response_media_type.manifest
      )
      # i sure there is an elegant way to do this in the response block
      manifest_file.close

      img.layers.each do |layer|
        next if img.layer_missing(layer['digest'])

        layer_file = File.new(img.layer_path(layer['digest']), 'w+')
        execute_request(
          'get',
          @base_uri + "/v2/#{repo}/blobs/#{layer['digest']}",
          response_block(layer_file),
          Accept: response_media_type.layer
        )
        layer_file.close
      
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
      # this coses the file to early (after the response_block method is done)
      #file.close
    end
  end
end
