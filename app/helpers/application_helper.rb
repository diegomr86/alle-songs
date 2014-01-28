
module ApplicationHelper
  def artist_custom_path(artist_name)
    artist_root_path(custom_artist_name(artist_name))
  end
  def artist_custom_url(artist_name)
    artist_root_url(custom_artist_name(artist_name))
  end
  def custom_artist_name(artist_name)
    artist_name.gsub("&", "e").gsub("/", "+").gsub(' ', '+').gsub('.', '+')
  end

end
