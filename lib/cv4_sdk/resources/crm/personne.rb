module Cv4SDK
  module Resources
    module Crm
      # This class handle both /personnes and crm/ endpoints data in CV4 (same data, named often as "Contact" in doc)
      class Personne < ::Cv4SDK::Resources::Base
        CREATE_PERSONNE_PARAMS =
          {
            crmId: {type: :string, required: true},
            nom: {type: :string, required: true},
            prenom: {type: :string, required: true},
            civilite: {type: :util_civilites},
            adresse: {type: :string},
            #city: {type: :string}, -> mentioned in pdf DOC BUT invalid params (BadRequest response when this is included)
            codePostal: {type: :string},
            ville: {type: :string},
            pays: {type: :country_iso_alpha_2},
            dateNaissance: {type: :date},
            villeNaissance: {type: :string},
            departementNaissance: {type: :util_departements},
            paysNaissance: {type: :country_iso_alpha_2},
            nationalite: {type: :country_iso_alpha_2},
            email: {type: :email},
            telephone: {type: :phone},
            telephoneMobile: {type: :phone},
            fax: {type: :string},
            champsPersonnalises: {
              type: :array,
              params:
                {
                  property: {type: :investisseur_champs_personnalises, required: true},
                  typeField: {type: :integer, required: true},
                  typeEntity: {type: :value_42, required: true},
                }
            }
          }

        class << self
          def create_or_update(params, verbose: false)
            Cv4SDK.request(:post, url, permitted_params(params, CREATE_PERSONNE_PARAMS), verbose: verbose)
          end

          LIST_WHITELIST_PARAMS = %w[nom prenom civilite ville email mobile fax adresse tel pays codePostal sort_by order limit offset]
          # DOC CV4 : Récupérer la liste des contacts dans l'application Capital Venture
          # NOTE : 30/04/2024 offset does not work
          def list(filters = nil)
            Cv4SDK.request(:get, url(namespace: "crm"), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
          end

          # GET ONLY PARAMS : %w[addresse civilite codePostal email fax id mobile nom pays prenom systemId tel ville]
          def get(systemId: nil, id: nil, verbose: false)
            if !id.nil?
              Cv4SDK.request(:get, url(scope: [id&.to_s], namespace: "crm"), verbose: verbose)
            elsif !systemId.nil?
              Cv4SDK.request(:get, url(scope: ["system_id", systemId&.to_s], namespace: "crm"), verbose: verbose)
            end
          end
        end
      end
    end
  end
end
