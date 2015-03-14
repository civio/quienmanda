class TopicsController < ApplicationController
  etag { can? :manage, Topic } # Don't cache admin content together with the rest

  # GET /topic
  def index
    @title = 'Temas'
    @topics = (can? :manage, Topic) ? Topic.all : Topic.published
  end

  # GET /topic/1
  # The topic may or may not exist, which can be a bit confusing, for historical reasons.
  # If no topic exists, we just show photos, post and entities with that given tag.
  # If the topic does exist, we additionally show a main entity, and a description.
  # This behaviour is inspired by the way Stack Overflow tag pages work.
  def show
    # Look for the topic
    topic = Topic.find_by_slug(params[:id])
    topic_id = params[:id].gsub('-', ' ')
    @title = topic ? topic.title : topic_id

    # If it does exist, retrieve the extra information
    if topic
      authorize! :read, topic   # Check it's been published
      if !topic.description.blank?
        @description = topic.description 
      end
      if topic.entity_id
        authorize! :read, Entity
        @entity = Entity.find(topic.entity_id)
      end
    end

    authorize! :read, Entity
    @related_entities = Entity.tagged_with(topic_id)

    authorize! :read, Post
    @posts = Post.tagged_with(topic_id)
    @posts = @posts.order("published_at DESC")

    authorize! :read, Photo
    @photos = Photo.tagged_with(topic_id)
    @photos =  @photos.order("updated_at DESC")
  end

end
