json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :name, :playitems_count
  json.url playlist_url(playlist, format: :json)
end
