json.array!(@topics) do |topic|
  json.extract! topic, :title
  json.url topic_url(topic, format: :json)
end
