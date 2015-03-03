class TopicsController < ApplicationController
  etag { can? :manage, Topic } # Don't cache admin content together with the rest

  # GET /topic
  def index
    @title = 'Temas'
    @topics = Topic.all
    #@topics = (can? :manage, Topic) ? Topic.all : Topic.published
  end

  # GET /topic/1
  def show
  	topic = Topic.find_by_slug(params[:id])
    topic_id = params[:id].gsub('-', ' ')

    @title = topic ? topic.title : topic_id

    if topic 
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
