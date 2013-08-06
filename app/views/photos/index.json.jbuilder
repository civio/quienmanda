json.array!(@photos) do |photo|
  json.extract! photo, :footer, :file
  json.url photo_url(photo, format: :json)
end
