module Cv4SDK
  module Resources
    module Crm
      class Societe < ::Cv4SDK::Resources::Base
        class << self
          CREATE_SOCIETE_WHITELIST_PARAMS = %w[crmId numeroRue rue codePostal ville pays email emailSecondaire telephone telephoneMobile fax raisonSociale typeSociete abreviation devise formeJuridique agrementAMF numTVAIntracommunautaire dateCreation siren siret secteurActivite codeParticipation commentairesInvestissement zoneIntervention activiteDetaillee departement dateDemarrageInvestissement commentaireSurStrategieInvestissement]
          REQUIRED_PARAMS = %w[raisonSociale devise crmId]
          def create_or_update(params)
            params = stringify_keys(params)
            if params.has_key?("systemId")
              # Because for some reason in API CV4 the name of the field for creation/modification is crmId,
              # but it is then returned as systemId...
              params["crmId"] = params.delete("systemId")
            end
            params = params&.slice(*CREATE_SOCIETE_WHITELIST_PARAMS)
            Cv4SDK.request(:post, url, params)
          end
        end
      end
    end
  end
end
