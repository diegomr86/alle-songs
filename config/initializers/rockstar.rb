Rockstar::Artist.class_eval do
  def search(force=false)
    { artists: get_instance("artist.search", :artists, :artist, {:artist => @name, limit: 8}, force),
      albums: get_instance("album.search", :albums, :album, {:album => @name, limit: 8}, force),
      tracks: get_instance("track.search", :tracks, :track, {:track => @name, limit: 10}, true)
    }
  end
end