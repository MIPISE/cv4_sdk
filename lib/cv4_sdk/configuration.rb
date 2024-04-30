module Cv4SDK
  class Configuration
    attr_accessor :api_root_url, :api_scope, :user_name, :password, :api_version

    def base_api_url
      "#{api_root_url}/#{api_scope}/ressource/#{api_version}"
    end

    def api_uri(url="")
      URI(base_api_url + url)
    end
  end
end
