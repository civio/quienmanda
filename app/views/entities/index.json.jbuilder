json.array!(@entities) do |entity|
  if entity.short_name? 
    json.set! :name, entity.short_name
  else
    json.set! :name, entity.name
  end
  if entity.person? 
    json.url person_url(entity, format: :json)
  else
    json.url organization_url(entity, format: :json)
  end
end
