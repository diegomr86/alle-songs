Rockstar::Artist.class_eval do
  def search(force=false)
    { artists: get_instance("artist.search", :artists, :artist, {:artist => @name, limit: 6}, force),
      albums: get_instance("album.search", :albums, :album, {:album => @name, limit: 6}, force),
      tracks: get_instance("track.search", :tracks, :track, {:track => @name, limit: 6}, true)
    }
  end
end
