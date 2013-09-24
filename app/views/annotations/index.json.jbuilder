json.array!(@annotations) do |annotation|
  json.extract! annotation, :id, :data
end
