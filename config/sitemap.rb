require 'open-uri'
host "www.allesongs.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :artists do
  JSON.parse(open("http://www.vagalume.com.br/api/rank.php?type=art&period=month&scope=translations&limit=1000").read)['art']['month']['all'].each do |artist|
     url artist_root_url(artist['name'].gsub("&", "e").gsub("/", "+").gsub(' ', '+')), last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end