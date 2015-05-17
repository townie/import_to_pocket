require 'sinatra'
require 'sinatra/activerecord'
require 'markio'

class Bookmark < ActiveRecord::Base
  belongs_to :user

  def self.import_from_file(filename='bookmarks_5_15_15.html')
    bookmarks = Markio::parse(File.open(filename))
    bookmarks.each do |b|
      b.title           # String
      b.href            # String with bookmark URL
      b.folders         # Array of strings - folders (tags)
      b.add_date        # DateTime
      b.last_visit      # DateTime
      b.last_modified   # DateTime
    end

    bookmarks.each do |bookmark|
      Bookmark.new bookmark
    end
  end

end
