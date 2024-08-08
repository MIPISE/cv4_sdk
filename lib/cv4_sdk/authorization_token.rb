module Cv4SDK
  module AuthorizationToken
    def storage
      @@storage ||= StaticStorage.new
    end

    def storage= (storage)
      @@storage = storage
    end

    def get_token(verbose: false)
      token = storage.get
      if token.nil?
        token = new_token(verbose: verbose)
        storage.store(token)
      end
      puts "returned token : <#{token}>" if verbose
      token
    end

    def new_token(verbose: false)
      res = Cv4SDK.request(:get, "/authentifications/head", {}, headers: request_headers(auth_mode: :credentials, verbose: verbose), verbose: verbose)
      res["token"]
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
