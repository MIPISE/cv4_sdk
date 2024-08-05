module Cv4SDK
  module AuthorizationToken
    def storage
      @@storage ||= StaticStorage.new
    end

    def storage= (storage)
      @@storage = storage
    end

    def get_token
      token = storage.get
      if token.nil?
        res = Cv4SDK.request(:get, "/authentifications/head", {}, headers: request_headers(auth_mode: :credentials))
        token = res["token"]
        storage.store(token)
      end
      token
    end

    def remove_token
      storage.store(nil)
    end

    def valid_token?(token)
      Cv4SDK.request(:get, "/utils/tokens/#{token}", {})
    end

    class StaticStorage
      def get
        @@token ||= nil
      end

      def store(token)
        @@token = token
      end
    end
  end
end
