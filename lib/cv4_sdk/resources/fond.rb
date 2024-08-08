module Cv4SDK
  module Resources
    class Fond < Base
      class << self
        def get_titres_list(fondsId, verbose: false)
          Cv4SDK.request(:get, url(scope: ["titre", fondsId.to_s]), verbose: verbose)
        end

        def list_fcp(verbose: false)
          Cv4SDK.request(:get, url(scope: "fcp"), verbose: verbose)
        end

        def list_fonds_mandat(verbose: false)
          Cv4SDK.request(:get, url(scope: "mandat"), verbose: verbose)
        end
      end
    end
  end
end
