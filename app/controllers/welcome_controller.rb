class WelcomeController < ApplicationController
  def index
    # Highlight manually curated articles in the frontpage
    @highlights = Post.where(featured: true).order("updated_at desc")
    @highlights = @highlights.published() unless can? :manage, Post

    # Show the normal posts also
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.order("updated_at DESC").page(params[:page]).per(6)
  end
end
