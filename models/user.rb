require 'sinatra'
require 'sinatra/activerecord'

class User < ActiveRecord::Base
  has_many :bookmarks
end
