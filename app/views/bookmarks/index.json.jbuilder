json.array!(@bookmarks) do |bookmark|
  json.extract! bookmark, :bookmark_type, :user_id, :value, :cover
  json.url bookmark_url(bookmark, format: :json)
end
