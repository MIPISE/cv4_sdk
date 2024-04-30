require "cgi/util"

module Cv4SDK
  module Resources
    class Base
      class << self
        def api_namespace
          "#{name.split("::").last.downcase}s"
        end

        def url(id = nil, scope: [])
          if self == Base
            raise NotImplementedError.new("Resource is an abstract class and must not be used directly.")
          else
            scope ||= []
            scope.unshift(api_namespace)
            scope << id if id
            scope.inject(Cv4SDK.api_uri) do |memo, scope|
              "#{memo}/#{CGI.escape(scope)}"
            end
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
