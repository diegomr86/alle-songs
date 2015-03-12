require 'open-uri'

host "www.allesongs.com"

Rockstar.lastfm = {:api_key => "534b78cd8e40fe67e31b50b9693ae512", :api_secret => "abc7b7049ad4e653783023075ca14e73"}

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :artists do
  (1...5).each do |i|
    Rockstar::Chart.get_instance("chart.getTopArtists", :artists, :artist, {limit: 1000, page: i}, false).each do |artist|
      url artist_root_url(URI.escape(artist.name.gsub("&", "e").gsub("/", "+").gsub('.', ' '))), last_mod: Time.now, change_freq: "daily", priority: 1.0
    end
  end
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
  Rockstar::Tag.get_instance("tag.getTopTags", :top_tags, :tag, {limit: 1000}, false).each do |tag|
    url tag_url(URI.escape(tag.name.gsub("&", "e").gsub("/", "+").gsub('.', ' '))), last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end
