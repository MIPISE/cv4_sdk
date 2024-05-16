module Cv4SDK
  module Resources
    module Crm
      class Societe < ::Cv4SDK::Resources::Base
        CREATE_UPDATE_PARAMS =
          {
            crmId: {type: :string, required: true},
            adresse: {type: :string},
            codePostal: {type: :string},
            ville: {type: :string},
            pays: {type: :country_iso_alpha_2},
            email: {type: :email},
            emailSecondaire: {type: :email},
            telephone: {type: :phone},
            telephoneMobile: {type: :phone},
            fax: {type: :string},
            raisonSociale: {type: :string, required: true},
            abreviation: {type: :string},
            typeSociete: {type: :util_type_societe},
            devise: {type: :devise_iso_4217},
            formeJuridique: {type: :util_forme_juridique},
            agrementAMF: {type: :string},
            numTVAIntracommunautaire: {type: :string},
            dateCreation: {type: :date},
            siren: {type: :string},
            siret: {type: :string},
            secteurActivite: {type: :util_secteur_activite_ste},
            codeParticipation: {type: :string},
            departement: {type: :util_departements},
            commentairesInvestissement: {type: :string},
            zoneIntervention: {type: :string},
            activiteDetaillee: {type: :string},
            dateDemarrageInvestissement: {type: :date},
            commentaireSurStrategieInvestissement: {type: :string}
          }
        class << self
          def create_or_update(params)
            Cv4SDK.request(:post, url, permitted_params(params, CREATE_UPDATE_PARAMS))
          end
        end
      end
    end
  end
end
