require 'pry'
module Sinatra
  module ImportToPocket
    module Routing
      module Secrets

        def self.registered(app)
          show_secrets = lambda do
            require_logged_in
            erb :secrets
          end

          play = lambda do
            binding.pry
          end
          app.get '/play', &play
          app.get  '/secrets', &show_secrets
        end

      end
    end
  end
end

