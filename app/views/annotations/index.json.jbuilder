json.array!(@annotations) do |annotation|
  json.extract! annotation, :id
  json.set! :data, JSON.parse(annotation.data)
end
