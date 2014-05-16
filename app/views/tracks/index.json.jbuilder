json.array!(@tracks) do |track|
  json.extract! track, :id, :track, :artist, :session_id
  json.url track_url(track, format: :json)
end
