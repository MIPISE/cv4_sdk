module Cv4SDK
  module Resources
    class Crm < Base
      class << self
        def api_namespace
          "crm" # this one has no "s" for some reason...
        end
        LIST_WHITELIST_PARAMS = %w[contact isSociete sort_by order limit offset]
        # DOC CV4 : Récupérer la liste des contacts dans l'application Capital Venture
        # NOTE : 30/04/2024 offset does not work
        def list(filters = nil)
          Cv4SDK.request(:get, url(scope: ["plugin-outlook"]), {}, stringify_keys(filters)&.slice(*LIST_WHITELIST_PARAMS))
        end

        # DOC CV4 : Création d'un contact
        def create(params)

        end
      end
    end
  end
end
