module Cv4SDK
  module Resources
    module Crm
      class Societe < ::Cv4SDK::Resources::Base
        CREATE_UPDATE_PARAMS =
          {
            abreviation: {type: :string},
            adresse: {type: :string},
            agrementAMF: {type: :string},
            codePostal: {type: :string},
            commentaireSurStrategieInvestissement: {type: :string},
            crmId: {type: :string, required: true},
            dateCreation: {type: :date},
            dateDemarrageInvestissement: {type: :date},
            devise: {type: :devise_iso_4217},
            email: {type: :email},
            emailSecondaire: {type: :email},
            fax: {type: :string},
            formeJuridique: {type: :util_forme_juridique},
            pays: {type: :country_iso_alpha_2},
            raisonSociale: {type: :string, required: true},
            telephone: {type: :phone},
            commentairesInvestissement: {type: :string},
            telephoneMobile: {type: :phone},
            typeSociete: {type: :util_type_societe},
            ville: {type: :string},
            numTVAIntracommunautaire: {type: :string},
            siren: {type: :string},
            siret: {type: :string},
            secteurActivite: {type: :util_secteur_activite_ste},
            codeParticipation: {type: :string},
            departement: {type: :util_departements},
            activiteDetaillee: {type: :string},
            zoneIntervention: {type: :string},
          }
        class << self
          def create_or_update(params)
            Cv4SDK.request(:post, url, permitted_params(params, CREATE_UPDATE_PARAMS))
          end

          def get(crmId, verbose: false)
            Cv4SDK.request(:get, url(crmId&.to_s), verbose: verbose)
          end
        end
      end
    end
  end
end
