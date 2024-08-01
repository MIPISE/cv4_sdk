require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "investisseurs list" do
  res = Cv4SDK::Resources::Investisseur.list(limit: 5)
  assert res.is_a?(Array)
  assert res.first.has_key?("investisseurName")
end

test "investisseurs create or update for a personne" do
  params =
  {
    information:
      [
        {
          crmId: @personne_jane_crm_id,
          nom: "Doe",
          prenom: "Jane",
          investisseur: {
            idExterne: @investisseur_jane_external_id,
            investisseurProfessionnel: "IP YES"
          }
        }
      ]
  }
  res = Cv4SDK::Resources::Investisseurs::Personne.create_or_update(params)
  assert (res["message"] == "Opération enregistrée avec succès")
end

test "investisseurs societe create or update" do
  newSocieteId = Time.now.to_i
  newInvestisseurId = Time.now.to_i + 1
  create_params =
    {
      information:
      [
        {
          systemId: newSocieteId,
          raisonSociale: "ABC raison sociale",
          investisseur: { idExterne: newInvestisseurId }
        }
      ]
    }
  res = Cv4SDK::Resources::Investisseurs::Societe.create_or_update(create_params)
  assert (res["message"] == "Opération enregistrée avec succès")
end

test "investisseurs get information" do
  res = Cv4SDK::Resources::Investisseur.find(@investisseur_jane_external_id)
  assert res.is_a?(Hash)
  assert res.has_key?("information")
  contact_res = res["information"].first
  assert contact_res["crmId"] == @personne_jane_crm_id.to_s
end
