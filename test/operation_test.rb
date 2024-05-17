require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "Operation get lists" do
  res = Cv4SDK::Resources::Operation.get_champs_personnalises
  assert res.is_a?(Array)
  res = Cv4SDK::Resources::Operation.list_fcp
  assert res.is_a?(Array)
  assert res.first.has_key?("id")
  assert res.first.has_key?("value")
end

test "Operation engagement create or update" do
  idFonds = Cv4SDK::Resources::Fond.list_fcp.first["id"]
  idTitre = Cv4SDK::Resources::Fond.get_titres_list(idFonds).first["id"]
  typeOperId = Cv4SDK::Resources::Operation.list_fcp.select{|h| h["value"] == "Engagement" }.first["id"]
  investisseurId = 100
  params =
    {
      operations:
        [
          {
            typeOperId: typeOperId,
            idTitre: idTitre,
            idFonds: idFonds,
            idExternInvestisseur: investisseurId,
            quantite: "10",
            montant: "100",
            devise: "EUR"
          }
        ]
    }
  res = Cv4SDK::Resources::Operation.create_or_update_engagement(params)
  assert (res["message"] == "Opération enregistrée avec succès")
end
