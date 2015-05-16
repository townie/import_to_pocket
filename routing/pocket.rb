require 'pocket-ruby'
module Sinatra
  module ImportToPocket
    module Routing
      module Pocket
        CALLBACK_URL = "http://localhost:9292/oauth/callback"

        def self.registered(app)
          oauth_callback = lambda do
            binding.pry
            puts "OAUTH CALLBACK"
            puts "request.url: #{request.url}"
            puts "request.body: #{request.body.read}"
            result = ::Pocket.get_result(session[:code], :redirect_uri => CALLBACK_URL)
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
            binding.pry

            session[:code] = ::Pocket.get_code(:redirect_uri => CALLBACK_URL)
            new_url = ::Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
            puts "new_url: #{new_url}"
            puts "session: #{session}"
            redirect new_url
          end

          add = lambda do
            client = ::Pocket.client(:access_token => session[:access_token])
            info = client.add :url => 'http://getpocket.com'
            "<pre>#{info}</pre>"
          end

          retrieve = lambda do
            client = ::Pocket.client(:access_token => session[:access_token])
          binding.pry
            info = client.retrieve(:detailType => :simple, :count => 420)
            ids = info["list"].map(&:first)

            "<pre>#{info}</pre>"
          end

          upload = lambda do
            client = ::Pocket.client(:access_token => session[:access_token])

            bookmarks.each do |book|
              new_bookmark = {}
              new_bookmark[:url] = book.href
              new_bookmark[:title] = book.title
              new_bookmark[:tags] = book.folders.concat(book.title.split(" ")).join(",")
              begin
                client.add new_bookmark
              rescue => e
                puts e.message
              end
            end

            bookmarks
          end

          app.get "/oauth/connect", &oauth_connect
          app.get "/oauth/callback", &oauth_callback
          app.get '/add', &add
          app.get "/retrieve", &retrieve
          app.get '/upload', &upload
        end

      end
    end
  end
end


