module Cv4SDK
  module Resources
    class Fond < Base
      class << self
        def get_titres_list(fondsId)
          Cv4SDK.request(:get, url(scope: ["titre", fondsId.to_s]))
        end

        def list_fcp
          Cv4SDK.request(:get, url(scope: "fcp"))
        end

        def list_fonds_mandat
          Cv4SDK.request(:get, url(scope: "mandat"))
        end
      end
    end
  end
end
