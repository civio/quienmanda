json.extract! @post, :author, :title, :published_at, :lead, :tag_list
json.content raw(@content)
json.related_entities @related_entities