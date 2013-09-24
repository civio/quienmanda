json.extract! @annotation, :id
json.set! :data, JSON.parse(@annotation.data)
json.extract! @annotation, :created_at, :updated_at