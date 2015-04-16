json.extract! @annotation, :id
json.data do
  if @annotation.entity
    if @annotation.entity.description
      json.set! :text, '<a href="'+entity_path(@annotation.entity)+'">'+JSON.parse(@annotation.data)['text']+'</a><p>'+@annotation.entity.description+'</p>'
    else
      json.set! :text, '<a href="'+entity_path(@annotation.entity)+'">'+JSON.parse(@annotation.data)['text']+'</a>'
    end
  else
    json.set! :text, JSON.parse(@annotation.data)['text']
  end
  json.set! :name, JSON.parse(@annotation.data)['text']
  json.set! :src, JSON.parse(@annotation.data)['src']
  json.set! :shapes, JSON.parse(@annotation.data)['shapes']
  json.set! :context, JSON.parse(@annotation.data)['context']
end
json.extract! @annotation, :created_at, :updated_at