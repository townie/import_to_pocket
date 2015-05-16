module Sinatra
  module ImportToPocket
    module Routing
      module Pocket

        def self.registered(app)
          oauth_callback = lambda do
            puts "OAUTH CALLBACK"
            puts "request.url: #{request.url}"
            puts "request.body: #{request.body.read}"
            result = Pocket.get_result(session[:code], :redirect_uri => CALLBACK_URL)
            session[:access_token] = result['access_token']
            puts result['access_token']
            puts result['username']
            # Alternative method to get the access token directly
            #session[:access_token] = Pocket.get_access_token(session[:code])
            puts session[:access_token]
            puts "session: #{session}"
            redirect "/"
          end

          oauth_connect = lambda do
            puts "OAUTH CONNECT"
            session[:code] = Pocket.get_code(:redirect_uri => CALLBACK_URL)
            new_url = Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
            puts "new_url: #{new_url}"
            puts "session: #{session}"
            redirect new_url
          end

          app.get "/oauth/connect", &oauth_connect
          app.get "/oauth/callback", &oauth_callback
        end

      end
    end
  end
end


