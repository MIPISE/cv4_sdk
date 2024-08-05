require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "crm list" do
  res = Cv4SDK::Resources::Crm::Personne.list(limit: 5)
  assert res.is_a?(Hash)
  assert res["rows"].is_a?(Array)
  assert res["rows"].first.has_key?("email")
end

test "crm personne" do
  email = "janedoe#{Time.now.to_i}@test.com"
  personne_params =
    {
      crmId: @personne_jane_crm_id,
      nom: "Doe",
      prenom: "Jane",
      civilite: Cv4SDK::Resources::Util.civilites.first["id"],
      adresse: "2 rue de loin",
      codePostal: "01231",
      ville: "Testville",
      pays: "FR",
      dateNaissance: "1985-01-01",
      villeNaissance: "TestvilleNaissance",
      departementNaissance: Cv4SDK::Resources::Util.departements.first["id"],
      paysNaissance: "FR",
      nationalite: "FR",
      email: email,
      telephone: "0102030405",
      telephoneMobile: "0504030405",
      fax: "0346758493"
    }
  res = Cv4SDK::Resources::Crm::Personne.create_or_update(personne_params)
  assert res.is_a?(Hash)
  assert (res["message"] == "Opération effectuée avec succès")
  pres = Cv4SDK::Resources::Crm::Personne.get(@personne_jane_crm_id)
  assert pres.is_a?(Hash)
  assert (pres["email"] == email)
end

test "crm societe" do
  raisonSociale = "SomeRaisonSociale#{Time.now.to_i}"
  crmId = 10
  res =
    Cv4SDK::Resources::Crm::Societe
      .create_or_update(
        {
          systemId: crmId,
          adresse: "42 rue de la réponse",
          codePostal: "42001",
          ville: "HitchHicker",
          pays: "GA",
          email: "promail@test.com",
          telephone: "0601020304",
          raisonSociale: raisonSociale,
          siren: "123456789123",
          siret: "123456789",
          devise: "EUR"
        }
      )
  assert res.is_a?(Hash)
  assert (res["message"] == "Opération effectuée avec succès")
  res = Cv4SDK::Resources::Crm::Societe.get(crmId)
  assert res.is_a?(Hash)
  assert (res["raisonSociale"] == raisonSociale)
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
