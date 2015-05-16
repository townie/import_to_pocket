class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |b|
      b.text :title           # String
      b.text :href            # String with bookmark URL
      b.text :folders         # Array of strings - folders (tags)
      b.datetime :add_date        # DateTime
      b.datetime :last_visit      # DateTime
      b.datetime :last_modified   # DateTime
    end
  end
end
