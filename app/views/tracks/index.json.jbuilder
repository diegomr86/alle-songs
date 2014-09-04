json.array!(@tracks) do |track|
  json.extract! track, :id, :name, :artist, :picture, :duration, :session_id
  json.url track_url(track, format: :json)
end
