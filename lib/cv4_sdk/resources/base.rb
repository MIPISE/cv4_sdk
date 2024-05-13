require "cgi/util"

module Cv4SDK
  module Resources
    class Base
      class << self
        def api_namespace
          name.gsub("Cv4SDK::Resources::", "").split("::").map do |scope|
            case scope
              when "Crm", "Beneficiaire" then scope.downcase
              else
                "#{scope.downcase}s"
            end
          end
        end

        def url(id = nil, scope: [], namespace: api_namespace)
          if self == Base
            raise NotImplementedError.new("Resource is an abstract class and must not be used directly.")
          else
            scope =
              case scope.class.name
                when "NilClass" then []
                when "Array" then scope
                else
                  [scope]
              end
            prefix = namespace.is_a?(Array) ? namespace : [namespace]
            scope = prefix + scope
            scope << id if id
            scope.inject(Cv4SDK.api_uri) do |memo, scope|
              "#{memo}/#{CGI.escape(scope)}"
            end
          end
        end


        def self.get_request(scope)
          define_method scope.gsub("-", "_") do
            Cv4SDK.request(:get, url(scope: scope))
          end
        end

        def stringify_keys(params)
          return nil if params.nil?

          params.inject({}) do |memo, (k, v)|
            memo[k.to_s] = v
            memo
          end
        end
      end
    end
  end
end
