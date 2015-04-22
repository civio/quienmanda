class TopicsController < ApplicationController
  etag { can? :manage, Topic } # Don't cache admin content together with the rest

  # GET /topic
  def index
    @title = 'Temas'
    @topics = (can? :manage, Topic) ? Topic.all : Topic.published
    @topics = @topics.order("updated_at DESC")
  end

  # GET /topic/1
  # The topic may or may not exist, which can be a bit confusing, for historical reasons.
  # If no topic exists, we just show photos, post and entities with that given tag.
  # If the topic does exist, we additionally show a main entity, and a description.
  # This behaviour is inspired by the way Stack Overflow tag pages work.
  def show
    # Look for the topic
    topic = Topic.find_by_slug(params[:id])
    # TODO: Do we need this? In which cases exactly? The fact that we use tags on photos and
    # entities to relate them to a Topic, which is a proper model, makes this messy.
    topic_id = params[:id].gsub('-', ' ')
    @title = topic ? topic.title : topic_id

    # If it does exist, retrieve the extra information
    if topic
      authorize! :read, topic       # Check it's been published
      if !topic.description.blank?
        @description = topic.description 
      end
      if topic.entity_id
        @entity = Entity.find(topic.entity_id)
        authorize! :read, @entity   # Should be public if the topic also is, but just in case
      end
    end

    @related_entities = Entity.tagged_with(topic_id)
    @posts = Post.tagged_with(topic_id).order("published_at DESC")
    @photos = Photo.tagged_with(topic_id).order("updated_at DESC")

    # Facebook Open Graph metadata
    @fb_description = @description
    @fb_image_url = topic.photo.file.url(:full) unless topic.photo.nil? or topic.photo.file.nil?
  end

end
