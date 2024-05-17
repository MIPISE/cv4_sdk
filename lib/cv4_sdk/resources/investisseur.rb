module Cv4SDK
  module Resources
    class Investisseur < Base
      class << self
        LIST_WHITELIST_PARAMS = %w[contact sort_by order limit offset]

        def list(filters = nil)
          Cv4SDK.request(:get, url(scope: ["plugin-outlook"]), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
        end

        def find(idExterne, limit: 200)
          offset = 0
          investisseurs_list = list(limit: limit, offset: offset)
          investisseur_res = investisseurs_list.select { |i_hash| i_hash["idInvestisseur"] == idExterne.to_s }.first
          while investisseur_res.nil? && investisseurs_list.count == limit
            offset += limit
            investisseurs_list = list(limit: limit, offset: offset)
            investisseur_res = investisseurs_list.select { |i_hash| i_hash["idInvestisseur"] == idExterne.to_s }.first
          end
          investisseur_res
        end
      end
    end
  end
end
