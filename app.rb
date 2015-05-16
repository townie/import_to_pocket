require "pocket-ruby"
require 'sinatra/base'

require_relative 'helpers'
require_relative 'routing/secrets'
require_relative 'routing/sessions'
require_relative 'routing/pocket'
require_relative 'models/bookmark'

class ImportToPocket < Sinatra::Base

  set :root, File.dirname(__FILE__)

  enable :sessions

  Pocket.configure do |config|
    config.consumer_key = '41250-09dbdada46a9ef6ba88d41ee'
  end

  helpers Sinatra::ImportToPocket::Helpers

  register Sinatra::ImportToPocket::Routing::Pocket
  register Sinatra::ImportToPocket::Routing::Sessions
  register Sinatra::ImportToPocket::Routing::Secrets
end
