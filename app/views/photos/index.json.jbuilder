json.array!(@photos) do |photo|
  json.extract! photo, :title, :file
  json.url photo_url(photo, format: :json)
end
