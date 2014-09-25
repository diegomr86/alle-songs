json.extract! @playlist, :id, :name, :user_id, :session_id, :playitems_count, :created_at, :updated_at
json.url playlist_url(@playlist, format: :json)
