require "dotenv/load"

require_relative "../../lib/cv4_sdk"

def init_cv4_sdk
  Cv4SDK.remove_token
  Cv4SDK.configure do |config|
    config.api_root_url = ENV["CV4_BASE_URL"]
    config.api_scope = ENV["CV4_API_SCOPE"]
    config.user_name = ENV["CV4_USER_NAME"]
    config.password = ENV["CV4_USER_PASSWORD"]
    config.api_version = ENV["CV4_API_VERSION"]
  end
end

@personne_jane_crm_id = 5
@investisseur_jane_external_id = 55
