module DockerRegistryApi
  # Common operations for the Docker Registry API
  module Operations
    def pull(repo, tag = 'latest')
      img = Image.new(repo: repo, tag: tag)

      img.layers.each do |layer|
        next if img.layer_missing(l['digest'])
        execute_request(
          'get',
          full_url("/v2/#{repo}/blobs/#{layer['digest']}"),
          response_block(img, layer),
          Accept: response_media_type.layer
        )
      end
    end

    def response_block(img, layer)
      file = File.new("#{img.path}/#{layer['digest']}", 'w+')
      proc do |response|
        if response.code == '200'
          response.read_body do |chunk|
            file.write chunk
          end
        end
      end
    ensure
      file.close
    end
  end
end
