require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "investisseurs list" do
  res = Cv4SDK::Resources::Investisseur.list(limit: 5)
  assert res.is_a?(Array)
  assert res.first.has_key?("investisseurName")
  investisseur_id = res.first["idInvestisseur"]
end

test "crm list" do
  res = Cv4SDK::Resources::Crm::Personne.list(limit: 5)
  assert res.is_a?(Hash)
  assert res["rows"].is_a?(Array)
  assert res["rows"].first.has_key?("email")
end

test "crm personne" do
  email = "janedoe#{Time.now.to_i}@test.com"
  res = Cv4SDK::Resources::Crm::Personne.create_or_update({systemId: 5, nom: "Doe", prenom: "Jane", email: email, "nationalite" => "FR"})
  assert res.is_a?(Hash)
  assert (res["message"] == "Opération effectuée avec succès")
  res = Cv4SDK::Resources::Crm::Personne.get(systemId: 5)
  assert res.is_a?(Hash)
  assert (res["email"] == email)
end

test "crm societe" do
  raisonSociale = "SomeRaisonSociale"
  res = Cv4SDK::Resources::Crm::Societe.create_or_update({ systemId: 10, raisonSociale: raisonSociale, devise: "EUR" })
  assert res.is_a?(Hash)
  assert (res["message"] == "Opération effectuée avec succès")
  # TODO : those lines below do not work for societe !!!
  # TODO : find out how to get this kind of data !!!
  # res = Cv4SDK::Resources::Crm::Resource.get(systemId: 10)
  # assert res.is_a?(Hash)
  # assert (res["raisonSociale"] == raisonSociale)
end


