module Cv4SDK
  module Resources
    class Util < Base
      class << self
        get_request "civilites"
        get_request "departements"
        get_request "forme-juridique"
        get_request "organes-direction"
        get_request "roles"
        get_request "secteur-activite-ste"
        get_request "status-mandataire"
        get_request "type-beneficiaire"
        get_request "type-societe"
        get_request "types-role"

        def get_id_from(list_scope, value)
          res = send(list_scope.gsub("-", "_"))
          hash = res.select { |h| h["value"] == value }.first
          return nil if hash.nil?

          hash["id"]
        end
      end
    end
  end
end
