json.extract! @track, :id, :name, :artist, :picture, :duration, :session_id, :created_at, :updated_at
json.url track_url(@track, format: :json)
