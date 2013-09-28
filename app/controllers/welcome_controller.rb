class WelcomeController < ApplicationController
  def index
    # Highlight manually curated articles in the frontpage
    @highlights = Post.where(featured: true).order("updated_at desc")
    @highlights = @highlights.published() unless can? :manage, Post

    # Show the latests posts...
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.order("updated_at DESC").limit(4)

    # ...and photos
    @photos = (can? :manage, Photo) ? Photo.all : Photo.published
    @photos = @photos.order("updated_at DESC").limit(6)
  end
end
