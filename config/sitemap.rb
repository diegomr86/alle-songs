require 'open-uri'

host "www.allesongs.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :artists do
  Artist.find_each do |artist|
    url artist_root_url(URI.escape(artist.name.gsub("&", "e").gsub("/", "+").gsub('.', ' '))), last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end

sitemap :albums do
  Album.find_each do |album|
    url artist_album_root_url(URI.escape(album.name.gsub("&", "e").gsub("/", "+").gsub('.', ' ')), URI.escape(album.artist.gsub("&", "e").gsub("/", "+").gsub('.', ' '))), last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end

sitemap :tags do
  Rockstar::Tag.top_tags.each do |tag|
    url tag_url(URI.escape(tag.name.gsub("&", "e").gsub("/", "+").gsub('.', ' '))), last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end
