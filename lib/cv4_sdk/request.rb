require "net/http"
require "json"
require "multi_json"

module Cv4SDK
  module Request
    def request(method, url_or_path, params={}, filters={}, headers: nil)
      uri =
        if url_or_path =~ /\A#{api_uri}.*\z/
          URI(url_or_path)
        else
          api_uri(url_or_path)
        end
      uri.query = URI.encode_www_form(filters) unless filters.empty?
      headers ||= request_headers
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
        req.body = MultiJson.dump(params) unless params.empty?
        http.request(req)
      end
      raise "ResponseError 408 RequestTimeout for #{uri.request_uri}" if res.nil?
      body_data = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)
      if res.is_a?(Net::HTTPOK)
        body_data
      else
        raise "ResponseError #{res.code} #{res.message} for #{uri.request_uri} (params : #{body_data})"
        res
      end
    end

    def request_headers
      auth_token = Cv4SDK.get_token
      {
        "token" => auth_token,
        "Content-Type" => "application/json;charset=Cp1252"
      }
    end
  end
end
