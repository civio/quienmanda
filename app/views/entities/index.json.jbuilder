json.array!(@entities) do |entity|
  json.extract! entity, :name, :short_name
  if entity.person? 
    json.url person_url(entity, format: :json)
  else
    json.url organization_url(entity, format: :json)
  end
end
