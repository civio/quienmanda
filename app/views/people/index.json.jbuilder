json.array!(@people) do |person|
  json.extract! person, :name, :short_name
  json.url person_url(person, format: :json)
end
