
module ApplicationHelper
  def artist_custom_path(artist_name)
    artist_root_path(artist_name.gsub("&", "e").gsub("/", "+").gsub(' ', '+'))
  end
  def artist_custom_url(artist_name)
    artist_root_url(artist_name.gsub("&", "e").gsub("/", "+").gsub(' ', '+'))
  end
end
