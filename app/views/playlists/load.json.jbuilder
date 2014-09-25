json.array!(@playitems) do |playitem|
  json.extract! playitem, :id, :name, :artist, :picture, :duration, :playlist_id
  json.url playitem_url(playitem, format: :json)
end
