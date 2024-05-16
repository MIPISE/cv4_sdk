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
                downcase_scope = scope.downcase
                downcase_scope[-1] == "s" ? downcase_scope : "#{downcase_scope}s"
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

        def stringify_keys(params, convert_system_to_crm: true)
          return nil if params.nil?

          case params.class.name
            when "Hash"
              params.inject({}) do |memo, (k, v)|
                string_key = k.to_s
                if convert_system_to_crm
                  if string_key =~ /\AsystemId(\w*)\z/
                    string_key = string_key.gsub("systemId", "crmId")
                  end
                end
                memo[string_key] = stringify_keys(v, convert_system_to_crm: convert_system_to_crm)
                memo
              end
            when "Array" then params.map { |p| stringify_keys(p, convert_system_to_crm: convert_system_to_crm) }
            else
              params
          end
        end

        def permitted_params(params, authorized_params)
          return nil if params.nil?

          authorized_params = stringify_keys(authorized_params, convert_system_to_crm: false)
          params = stringify_keys(params)
          res =
            case params.class.name
              when "Array"
                raise "InvalidParamsError", "You should only use Hash params, never Array (please ?)"
              when "Hash"
                params.inject({}) do |memo, (key, value)|
                  authorized_param = authorized_params[key]
                  next memo if authorized_param.nil?

                  case authorized_param["type"].to_sym
                    when :hash
                      memo[key] = permitted_params(params[key], authorized_params[key]["params"])
                    when :array
                      memo[key] = params[key].map { |key_p| permitted_params(key_p, authorized_params[key]["params"]) }
                    else
                      memo[key] = value
                  end
                  memo
                end
              else
                params
            end
          res
        end

        # Ensure all required params are present.
        def missing_required_params_message(params, authorized_params)
          missing_params = missing_required_params(params, authorized_params)
          if missing_params&.any?
            "#{missing_params.count} paramètre#{"s" if missing_params.count > 1} manquant : #{missing_params.join(", ")}"
          else
            nil
          end
        end

        # Ensure all required params are present.
        def missing_required_params(params, authorized_params)
          params ||= {}

          case params.class.name
            when "Hash"
              authorized_params = stringify_keys(authorized_params, convert_system_to_crm: false)
              params = stringify_keys(params)
              authorized_params.inject([]) do |memo, (key, p_hash)|
                next memo if p_hash.nil?

                # que ce soit un champs required ou non, si la clé est présente dans les params
                # on veut s'assurer que la structure est en elle-même valide, qu'elle répond
                # aux critères.
                if p_hash.has_key?("params") && params.has_key?(key)
                  memo += missing_required_params(params[key], p_hash["params"])
                elsif p_hash["required"]
                  if params[key].nil?
                    memo << key
                  end
                  if p_hash.has_key?("params")
                    memo += missing_required_params(params[key], p_hash["params"])
                  end
                end
                memo
              end
            when "Array"
              params.map { |p| missing_required_params(p, authorized_params) }.flatten
            else
              []
          end
        end
      end
    end
  end
end
