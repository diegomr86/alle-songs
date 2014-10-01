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

def artist_custom_path(artist_name)
  artist_root_path(custom_artist_name(artist_name))
end
def artist_custom_url(artist_name)
  artist_root_url(custom_artist_name(artist_name))
end
def custom_artist_name(artist_name)
  URI.escape(artist_name.gsub("&", "e").gsub("/", "+").gsub('.', ' '))
end
