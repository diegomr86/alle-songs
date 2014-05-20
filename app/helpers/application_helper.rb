
module ApplicationHelper
  def artist_custom_path(artist_name)
    artist_root_path(custom_artist_name(artist_name))
  end
  def artist_custom_url(artist_name)
    artist_root_url(custom_artist_name(artist_name))
  end
  def custom_artist_name(artist_name)
    artist_name.gsub("&", "e").gsub("/", " ").gsub('.', ' ')
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end


end
