json.extract! @playitem, :id, :name, :artist, :picture, :duration, :playlist_id, :created_at, :updated_at
json.url playitem_url(@playitem, format: :json)
