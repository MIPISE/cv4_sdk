require_relative "cv4_sdk/configuration"
require_relative "cv4_sdk/request"
require_relative "cv4_sdk/authorization_token"
require_relative "cv4_sdk/resources/base"
require_relative "cv4_sdk/resources/investisseur"
require_relative "cv4_sdk/resources/crm/beneficiaire"
require_relative "cv4_sdk/resources/crm/personne"
require_relative "cv4_sdk/resources/crm/role"
require_relative "cv4_sdk/resources/crm/societe"
require_relative "cv4_sdk/resources/investisseurs/personne"
require_relative "cv4_sdk/resources/investisseurs/societe"
require_relative "cv4_sdk/resources/fond"
require_relative "cv4_sdk/resources/operation"
require_relative "cv4_sdk/resources/util"


module Cv4SDK
  class << self
    attr_accessor :config, :utils

    def config
      @config ||= Configuration.new
    end

    def utils
      @utils ||= Cv4SDK::Resources::Util
    end

    def configure
      conf = self.config
      yield conf
      self.config = conf
    end

    def api_uri(url="")
      config.api_uri(url)
    end

    include Request
    include AuthorizationToken
  end
end
