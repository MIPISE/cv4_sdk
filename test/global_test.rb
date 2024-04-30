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
  res = Cv4SDK::Resources::Crm.list(limit: 5)
  assert res.is_a?(Array)
  assert res.first.has_key?("contactName")
  contact_id = res.first["idContact"]
end

