module Cv4SDK
  module Resources
    class Operation < Base
      class << self
        def get_champs_personnalises
          Cv4SDK.request(:get, url(scope: ["detailInvest", "champs-personnalises"]))
        end

        def list_fcp
          Cv4SDK.request(:get, url(scope: "fcp"))
        end

        CREATE_UPDATE_ENGAGEMENT_PARAMS =
          {
            operations:
              {
              type: :array,
              required: true,
              params:
                {
                  typeOperId: {type: :operation_list_fcp, required: true},
                  idTitre: {type: :fond_get_titres_list, required: true},
                  idFonds: {type: :fond_list_fcp, required: true},
                  idExternInvestisseur: {type: :string, required: true},
                  quantite: {type: :string, required: true},
                  montant: {type: :string, required: true},
                  devise: {type: :util_devises},
                  detailSouscripteur:
                    {
                      type: :hash,
                      params:
                        {
                          isRemploi: {type: :string_bool},
                          dateSortie: {type: :date},
                          isActif: {type: :string_bool},
                          isDefault: {type: :string_bool},
                          idGroup: {type: :util_groupes_investisseurs},
                          idNatInvestissement: {type: :util_natures_operation_investissement},
                          idIntermediaire: {type: :string},
                          champsPersonnalises:
                            {
                              type: :array,
                              params:
                                {
                                  property: {type: :investisseur_champs_personnalises, required: true},
                                  typeField: {type: :integer, required: true},
                                  typeEntity: {type: :value_48, required: true},
                                }
                            }
                        }
                    }
                }
            }
          }

        def create_or_update_engagement
          Cv4SDK.request(:post, url(scope: "engagement"))
        end
      end
    end
  end
end
