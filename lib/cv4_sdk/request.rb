require "net/http"
require "json"
require "multi_json"
require "base64"

module Cv4SDK
  module Request
    def request(method, url_or_path, params={}, filters={}, headers: nil, verbose: false)
      uri =
        if url_or_path =~ /\A#{api_uri}.*\z/
          URI(url_or_path)
        else
          api_uri(url_or_path)
        end
      uri.query = URI.encode_www_form(filters) unless filters.nil? || filters.empty?
      headers ||= request_headers(auth_mode: (method.to_sym == :get ? :token : :credentials), verbose: verbose)
      if verbose
        puts "Request #{method.upcase} on #{uri.to_s} - params : #{params} - filters : #{filters} - headers : #{headers}"
      end
      res =
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
          req.body = MultiJson.dump(params) unless params.empty?
          http.request(req)
        end
      if res.nil?
        return { "error" => { "code" => "408", "message" => "RequestTimeout for #{uri.request_uri}", "uri" => uri.request_uri, origin_params: params}}
      elsif verbose
        puts "*** Successful request over #{uri.request_uri} ***"
      end

      body_data =
        if res.body.to_s.empty?
          {}
        else
          begin
            JSON.load(res.body.to_s)
          rescue JSON::ParserError
            { "message" => res.body.to_s }
          end
        end
      if res.is_a?(Net::HTTPOK) || res.is_a?(Net::HTTPCreated)
        puts "Response : #{res.body}" if verbose
        puts "Response body : #{body_data}" if verbose
        body_data
      else
        return { "error" => { "code" => res.code, "message" => res.message, params: body_data, "uri" => uri.request_uri, origin_params: params } }
      end
    end

    def request_headers(auth_mode: :token, verbose: false)
      headers = {"Content-Type" => "application/json;charset=Cp1252", "Accept" => "application/json"}

      if auth_mode.to_sym == :token
        headers["token"] = Cv4SDK.get_token(verbose: verbose)
      else
        headers["username"] = Cv4SDK.config.user_name
        headers["password"] = Cv4SDK.config.password
      end
      puts "headers : #{headers}" if verbose
      headers
    end
  end
end
