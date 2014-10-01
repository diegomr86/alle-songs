
module ApplicationHelper
  def artist_custom_path(artist_name)
    artist_root_path(custom_artist_name(artist_name))
  end
  def artist_custom_url(artist_name)
    artist_root_url(custom_artist_name(artist_name))
  end
  def custom_artist_name(artist_name)
    URI.escape(artist_name.gsub("/", " ").gsub('.', ' '))
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

  def track_thumb(track)
    track.images['extralarge'].present? ? track.images['extralarge'] : image_url('demo/avatars/1.jpg')
  end

  def track_json(track)
    {name: track.name, artist: track.artist, picture: track_thumb(track), duration: (Time.now.at_beginning_of_day + track.duration.seconds).strftime("%M:%S")}.to_json
  end
end
