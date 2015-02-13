class TopicController < ApplicationController

  # GET /topic/1
  def show

  	@title = params[:id]

  	authorize! :manage, Photo
    @photos = Photo.tagged_with(params[:id])

    authorize! :manage, Post
    @posts = Post.tagged_with(params[:id])
  end

end
