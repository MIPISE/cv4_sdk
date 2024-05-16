require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "utils lists" do
  Cv4SDK::Resources::Util::UTILS_REQUESTS_SCOPES.each do |scope|
    res = Cv4SDK::Resources::Util.send(scope.gsub("-", "_"))
    assert res.is_a?(Array)
  end
end
