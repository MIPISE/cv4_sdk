require_relative "support/helper"

setup do |client|
  init_cv4_sdk
end

test "get authorization token" do
  token = Cv4SDK.new_token(verbose: true)
  assert !token.nil?
end
