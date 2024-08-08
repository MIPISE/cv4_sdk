module Cv4SDK
  module Resources
    module Investisseurs
      class Personne < ::Cv4SDK::Resources::Base
        class << self
          def api_namespace
            ["investisseurs", "personne"]
          end

          CREATE_UPDATE_PARAMS =
            {
              information:
                {
                  type: :array,
                  params:
                    Cv4SDK::Resources::Crm::Personne::CREATE_PERSONNE_PARAMS.merge(
                      {
                        investisseur:
                          {
                            type: :hash,
                            required: false,
                            params:
                              {
                                idExterne: {type: :string, required: true},
                                categorieMIF: {type: :util_categorieMIF},
                                statutFiscal: {type: :util_statut_fiscal},
                                estDefaillant: {type: :string_boolean},
                                identifantFiscal1PaysOrigine: {type: :util_pays},
                                identifantFiscal1: {type: :string},
                                estPreleve: {type: :string_boolean},
                                typeProprietairePart: {type: :util_type_proprietaire_part},
                                investisseurProfessionnel: {type: :string},
                                category: {type: :util_categories},
                                etat: {type: :util_etats_investisseur},
                                compteBancaire:
                                  {
                                    type: :hash,
                                    required: false,
                                    params:
                                      {
                                        libelle: {type: :string},
                                        banque: {type: :string},
                                        iban: {type: :string, required: true},
                                        bic: {type: :string, required: true},
                                        codeBanque: {type: :string},
                                        domiciliation: {type: :string},
                                        numeroCompte: {type: :string},
                                        parDefaut: {type: :string_boolean},
                                      }
                                  },
                                mandatPrelevement:
                                  {
                                    type: :hash,
                                    required: false,
                                    params:
                                      {
                                        rum: {type: :string, required: true},
                                        fonds: {type: :fond_mandat, required: true},
                                        dateSignature: {type: :date},
                                        lieuSignature: {type: :fond_mandat},
                                        estActif: {type: :string_boolean}
                                      }
                                  },
                                contactAssocies:
                                  {
                                    type: :array,
                                    required: false,
                                    params:
                                      {
                                        crmId: {type: :string, required: true},
                                        civilite: {type: :string},
                                        nom: {type: :string, required: true},
                                        prenom: {type: :string, required: true},
                                        dateNaissance: {type: :date},
                                        phone: {type: :string},
                                        email: {type: :string},
                                        principal: {type: :string}
                                      }
                                  }
                              }
                          }
                      }
                    )
                }
            }

          def create_or_update(params)
            p = permitted_params(params, CREATE_UPDATE_PARAMS)
            if (message = missing_required_params_message(p, CREATE_UPDATE_PARAMS)).nil?
              Cv4SDK.request(:post, url, p)
            else
              puts message
              {"error" => {"code" => "0000", "message" => message}}
            end
          end
        end
      end
    end
  end
end
