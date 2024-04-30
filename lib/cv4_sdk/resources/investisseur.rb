module Cv4SDK
  module Resources
    class Investisseur < Base
      class << self
        LIST_WHITELIST_PARAMS = %w[contact sort_by order limit offset]

        def list(filters = nil)
          Cv4SDK.request(:get, url(scope: ["plugin-outlook"]), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
        end

        def create_societe(params)
          Cv4SDK.request(:post, url(scope: ["societe"]), params)
        end

        def create_personne(params)
          url(scope: ["personne"])
        end
      end
    end
  end
end
