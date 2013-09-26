class WelcomeController < ApplicationController
  def index
    # Highlight the latest three articles in the frontpage
    @highlights = Post.where("photo_id is not null").order("updated_at desc").limit(3)
    @highlights = @highlights.published() unless can? :manage, Post

    # Show the normal posts also
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.order("updated_at DESC").page(params[:page]).per(6)
  end
end
