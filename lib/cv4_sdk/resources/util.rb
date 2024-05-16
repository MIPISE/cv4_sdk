module Cv4SDK
  module Resources
    class Util < Base
      UTILS_REQUESTS_SCOPES =
        [
          "categorieMIF",
          "categories",
          "civilites",
          "departements",
          "devises",
          "etats-investisseur",
          "forme-juridique",
          "groupes-investisseurs",
          "organes-direction",
          "natures-operation-investissement",
          "pays",
          "roles",
          "secteur-activite-ste",
          "status-mandataire",
          "statut-fiscal",
          "type-beneficiaire",
          "type-proprietaire-part",
          "type-societe",
          "types-role"
        ]
      class << self
        UTILS_REQUESTS_SCOPES.each do |scope|
          get_request scope
        end

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
