class TopicController < ApplicationController

  # GET /topic/1
  def show
  	topic = Topic.find_by_slug(params[:id])
    #if stale?(topic, :public => current_user.nil?)

      @title = topic ? topic.title : params[:id].gsub('-', ' ')

      if topic and !topic.description.blank?
        @description = topic.description 
      end
      	
	    authorize! :read, Post
	    @posts = Post.tagged_with(@title.downcase)
    	@posts = @posts.order("published_at DESC")

    	authorize! :read, Photo
	    @photos = Photo.tagged_with(@title.downcase)
	    @photos =  @photos.order("updated_at DESC")
    #end
  end

end
