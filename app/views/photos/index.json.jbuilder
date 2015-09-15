json.array!(@photos) do |photo|
  json.extract! photo, :footer
  json.url photo_url(photo, format: :json)
end