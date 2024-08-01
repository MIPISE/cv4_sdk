module Cv4SDK
  module Resources
    class Investisseur < Base
      class << self
        LIST_WHITELIST_PARAMS = %w[contact sort_by order limit offset]

        def list(filters = nil)
          Cv4SDK.request(:get, url(scope: ["plugin-outlook"]), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
        end

        def find(idExterne, limit: 200)
          Cv4SDK.request(:get, url(idExterne&.to_s), {idExterne: idExterne&.to_s})
        end
      end
    end
  end
end
