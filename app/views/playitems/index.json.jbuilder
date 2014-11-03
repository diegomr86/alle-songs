json.array!(@playitems) do |playitem|
  json.extract! playitem, :id, :name, :artist, :picture, :duration, :playlist_id
  json.url playitem_url(playitem, format: :json)
  json.share_url playitem_url(playitem, share: 'true')
end
