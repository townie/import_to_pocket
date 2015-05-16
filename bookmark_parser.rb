
bookmarks = Markio::parse(File.open('bookmarks_5_15_15.html'))
bookmarks.each do |b|
  b.title           # String
  b.href            # String with bookmark URL
  b.folders         # Array of strings - folders (tags)
  b.add_date        # DateTime
  b.last_visit      # DateTime
  b.last_modified   # DateTime
end
