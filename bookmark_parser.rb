require 'markio'
require 'pry'
require "sinatra"
require "pocket-ruby"

bookmarks = Markio::parse(File.open('bookmarks_5_15_15.html'))
bookmarks.each do |b|
  b.title           # String
  b.href            # String with bookmark URL
  b.folders         # Array of strings - folders (tags)
  b.add_date        # DateTime
  b.last_visit      # DateTime
  b.last_modified   # DateTime
end

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Pocket.configure do |config|
  config.consumer_key = '41250-09dbdada46a9ef6ba88d41ee'
end

get '/reset' do
  puts "GET /reset"
  session.clear
end

get "/" do
  puts "GET /"
  puts "session: #{session}"

  if session[:access_token]
    '
    <a href="/add?url=http://getpocket.com">Add Pocket Homepage</a>
    <a href="/retrieve">Retrieve single item</a>
    '
  else
    '<a href="/oauth/connect">Connect with Pocket</a>'
  end
end

get "/oauth/connect" do
  puts "OAUTH CONNECT"
  session[:code] = Pocket.get_code(:redirect_uri => CALLBACK_URL)
  new_url = Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
  puts "new_url: #{new_url}"
  puts "session: #{session}"
  redirect new_url
end

get "/oauth/callback" do
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

get '/add' do
  client = Pocket.client(:access_token => session[:access_token])
  info = client.add :url => 'http://getpocket.com'
  "<pre>#{info}</pre>"
end

get "/retrieve" do
  client = Pocket.client(:access_token => session[:access_token])

  info = client.retrieve(:detailType => :simple, :count => 420)
  ids = info["list"].map(&:first)

  "<pre>#{info}</pre>"
end

get '/clearAll' do

end

def client
  client ||= Pocket.client(:access_token => session[:access_token])
end

get '/upload' do
  client = Pocket.client(:access_token => session[:access_token])

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
