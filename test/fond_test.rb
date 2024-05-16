require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "Fond get lists" do
  res = Cv4SDK::Resources::Fond.list_fcp
  assert res.is_a?(Array)
  assert res.first.has_key?("id")
  assert res.first.has_key?("value")
  fond_fcp_id = res.first["id"]
  res = Cv4SDK::Resources::Fond.list_fonds_mandat
  assert res.is_a?(Array)
  res = Cv4SDK::Resources::Fond.get_titres_list(fond_fcp_id)
  assert res.is_a?(Array)
  assert res.first.has_key?("id")
  assert res.first.has_key?("value")
end
