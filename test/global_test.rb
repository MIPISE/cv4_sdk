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

test "crm beneficiary link to societe" do
  societeCrmId = 10
  contactCrmId = 11
  res = Cv4SDK::Resources::Crm::Societe.create_or_update({ systemId: societeCrmId, raisonSociale: "SomeRaisonSociale", devise: "EUR" })
  assert res["error"].nil?
  res = Cv4SDK::Resources::Crm::Personne.create_or_update({systemId: contactCrmId, nom: "Doe", prenom: "Jane", email: "jane.doe@test.com"})
  assert res["error"].nil?
  # systemId: "Beneficiaire1",
  res = Cv4SDK::Resources::Crm::Beneficiaire.create_or_update({systemIdSource: societeCrmId, systemIdBeneficiaire: contactCrmId})
  assert res["error"].nil?
end

test "utils lists" do
  %w[civilites departements forme-juridique organes-direction roles secteur-activite-ste status-mandataire type-beneficiaire type-societe types-role].each do |scope|
    res = Cv4SDK::Resources::Util.send(scope.gsub("-", "_"))
    if res.is_a?(Array)
    else
      binding.irb
    end
    #assert res.is_a?(Array)
  end
end

test "crm role creation" do
  societeCrmId = 10
  representantCrmId = 12
  res = Cv4SDK::Resources::Crm::Societe.create_or_update({ systemId: societeCrmId, raisonSociale: "SomeRaisonSociale", devise: "EUR" })
  assert res["error"].nil?
  res = Cv4SDK::Resources::Crm::Personne.create_or_update({systemId: representantCrmId, nom: "Doe", prenom: "Donatella", email: "donatella.doe@test.com"})
  assert res["error"].nil?
  # systemId: "Beneficiaire1",
  res =
    Cv4SDK::Resources::Crm::Role
      .create_or_update(
        {
          systemIdCible: societeCrmId,
          typeRole: Cv4SDK.utils.get_id_from("types-role", "Dirigeants"),
          systemIdContact: societeCrmId,
          crmIdRepresentePar: representantCrmId,
          role: Cv4SDK.utils.get_id_from("roles", "Gérant")
        }
      )
  assert res["error"].nil?
end
