json.array!(@tracks) do |track|
  json.extract! track, :id, :name, :artist, :picture, :duration
  json.url track_url(track, format: :json)
end
