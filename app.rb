
require 'sinatra/base'

require_relative 'helpers'
require_relative 'routing/secrets'
require_relative 'routing/sessions'
require_relative 'routing/pocket'

class ImportToPocket < Sinatra::Base

  set :root, File.dirname(__FILE__)

  enable :sessions

  helpers Sinatra::ImportToPocket::Helpers

  register Sinatra::ImportToPocket::Routing::Pocket
  register Sinatra::ImportToPocket::Routing::Sessions
  register Sinatra::ImportToPocket::Routing::Secrets
end
