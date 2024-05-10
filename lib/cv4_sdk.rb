require_relative "cv4_sdk/configuration"
require_relative "cv4_sdk/request"
require_relative "cv4_sdk/authorization_token"
require_relative "cv4_sdk/resources/base"
require_relative "cv4_sdk/resources/investisseur"
require_relative "cv4_sdk/resources/crm/personne"
require_relative "cv4_sdk/resources/crm/societe"


module Cv4SDK
  class << self
    attr_accessor :config

    def config
      @config ||= Configuration.new
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
