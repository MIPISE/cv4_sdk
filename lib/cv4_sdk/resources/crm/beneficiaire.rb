module Cv4SDK
  module Resources
    module Crm
      # This class handle both /personnes and crm/ endpoints data in CV4 (same data, named often as "Contact" in doc)
      class Beneficiaire < ::Cv4SDK::Resources::Base
        class << self
          CREATE_BENEFICIAIRE_WHITELIST_PARAMS = %w[crmIdSource crmIdBeneficiaire commentaire typeBeneficiaire dateDeclarationEffective dateDebut dateFin beneficiaireEffectif pourcentage crmId]
          def create_or_update(params)
            params = stringify_keys(params)
            params = params&.slice(*CREATE_BENEFICIAIRE_WHITELIST_PARAMS)
            Cv4SDK.request(:post, url, params)
          end
        end
      end
    end
  end
end
