require 'rest-client'
require 'json'

module DockerRegistryApi
  # HTTP related functions
  module HTTP
    def execute_request(method, url, response_block, headers = {})
      response = RestClient::Request.execute(
        method: method,
        url: url,
        headers: headers,
        block_response: response_block
      )

      # TODO, prevent endless recursion
      case response.code
      when '401'
        bearer_header = response.header['www-authenticate']
        token = authenticate_bearer(bearer_header)
        headers = headers.merge(Authorization: 'Bearer ' + token)
        execute_request(method, url, response_block, headers)
      when '307'
        execute_request(
          method,
          response.header['location'],
          response_block,
          headers
        )
      end
    end

    def authenticate_bearer(header)
      target = split_auth_header(header)
      uri = URI.parse(target[:realm])

      unless @user.nil?
        target[:params][:account] = @user
        uri.user = @user
      end

      uri.password = @password unless @password.nil?

      response = RestClient.get(uri.to_s, params: target[:params])
      JSON.parse(response)['token']
    end

    def split_auth_header(header)
      h = { params: {} }
      header.split(/[\s,]+/).each do |entry|
        p = entry.split('=')
        case p[0]
        when 'Bearer'
          next
        when 'realm'
          h[:realm] = p[1].gsub(/(^\"|\"$)/, '')
        else
          h[:params][p[0]] = p[1].gsub(/(^\"|\"$)/, '')
        end
      end
      h
    end
  end
end
