module Cv4SDK
  module Resources
    module Crm
      # This class handle both /personnes and crm/ endpoints data in CV4 (same data, named often as "Contact" in doc)
      class Personne < ::Cv4SDK::Resources::Base
        class << self
          CREATE_PERSONNE_WHITELIST_PARAMS = %w[crmId nom prenom civilite adresse city codePostal ville Pays dateNaissance villeNaissance departementNaissance paysNaissance nationalite email telephone telephoneMobile fax]
          def create_or_update(params)
            params = stringify_keys(params)
            if params&.has_key?("systemId")
              # Because for some reason in API CV4 the name of the field for creation/modification is crmId,
              # but it is then returned as systemId...
              params["crmId"] = params.delete("systemId")
            end
            params = params&.slice(*CREATE_PERSONNE_WHITELIST_PARAMS)
            Cv4SDK.request(:post, url, params)
          end

          LIST_WHITELIST_PARAMS = %w[nom prenom civilite ville email mobile fax adresse tel pays codePostal sort_by order limit offset]
          # DOC CV4 : Récupérer la liste des contacts dans l'application Capital Venture
          # NOTE : 30/04/2024 offset does not work
          def list(filters = nil)
            Cv4SDK.request(:get, url(namespace: "crm"), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
          end

          # GET ONLY PARAMS : %w[addresse civilite codePostal email fax id mobile nom pays prenom systemId tel ville]
          def get(systemId: nil, id: nil)
            if !id.nil?
              Cv4SDK.request(:get, url(scope: [id&.to_s], namespace: "crm"))
            elsif !systemId.nil?
              Cv4SDK.request(:get, url(scope: ["system_id", systemId&.to_s], namespace: "crm"))
            end
          end
        end
      end
    end
  end
end
