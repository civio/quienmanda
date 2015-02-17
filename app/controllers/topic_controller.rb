class TopicController < ApplicationController

  # GET /topic/1
  def show
  	topic = Topic.find_by_slug(params[:id])
    if stale?(topic, :public => current_user.nil?)
      	@title = topic.title
      	@description = topic.description
      	
	    authorize! :manage, Post
	    @posts = Post.tagged_with(topic.title.downcase)
    	@posts = @posts.order("published_at DESC")

    	authorize! :manage, Photo
	    @photos = Photo.tagged_with(topic.title.downcase)
	    @photos =  @photos.order("updated_at DESC")
    end
  end

end
