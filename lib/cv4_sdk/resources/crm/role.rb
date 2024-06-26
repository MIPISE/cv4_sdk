module Cv4SDK
  module Resources
    module Crm
      # This class handle both /personnes and crm/ endpoints data in CV4 (same data, named often as "Contact" in doc)
      class Role < ::Cv4SDK::Resources::Base
        class << self
          CREATE_ROLE_WHITELIST_PARAMS = %w[crmIdCible typeRole crmIdContact crmIdRepresentePar role dateDebut dateFin interventionDirect fonctionExacte organeDirection statutMandataire salaire]
          def create_or_update(params)
            params = stringify_keys(params)
            params = params&.slice(*CREATE_ROLE_WHITELIST_PARAMS)
            Cv4SDK.request(:post, url, params)
          end
        end
      end
    end
  end
end
