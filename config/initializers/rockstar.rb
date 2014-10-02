Rockstar::Artist.class_eval do
  def search(force=false)
    { artists: get_instance("artist.search", :artists, :artist, {:artist => @name, limit: 8}, force),
      albums: get_instance("album.search", :albums, :album, {:album => @name, limit: 8}, force),
      tracks: get_instance("track.search", :tracks, :track, {:track => @name, limit: 10}, true)
    }
  end
end

Rockstar::Album.class_eval do
  def top_tracks(xml=nil)
    unless xml
      doc = self.class.fetch_and_parse("album.getInfo", {:artist => @artist, :album =>@name})
      xml = (doc / :album).first
    end

    puts xml

    return self if xml.nil?

    tracks = []
    (xml/'tracks/track').each {|track|
      tracks.push({ name: track.at(:name).inner_html, artist: track.at('artist/name').inner_html, duration: track.at(:duration).inner_html, url: track.at(:url).inner_html })
    }
    tracks
  end

  def top_tags(force=false)
    get_instance("album.getTopTags", :top_tags, :tag, {:album => @name, :artist => @artist}, force)
  end


end

Rockstar::Tag.class_eval do
  def similar(force=false)
    get_instance("album.getSimilar", :similartags, :tag, {:tag => @name}, force)
  end
end