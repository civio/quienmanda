json.array!(@people) do |person|
  json.extract! person, :name
  json.url person_url(person, format: :json)
end
