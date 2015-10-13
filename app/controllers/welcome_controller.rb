class WelcomeController < ApplicationController
  etag { current_user }         # Pages vary depending on whether user is logged on
  etag { can? :manage, Entity } # Pages seen as admin may look different

  def index    
    # Highlight manually curated articles in the frontpage
    @post_highlights = (can? :manage, Post) ? Post.all : Post.published
    @post_highlights = @post_highlights.where(featured: true).includes(:photo).order("published_at desc").limit(5)

    @topic_highlights = (can? :manage, Topic) ? Topic.all : Topic.published
    @topic_highlights = @topic_highlights.where(featured: true).order("featured_order ASC").limit(4)

    @highlights_items = @post_highlights.size + @topic_highlights.size

    # Show the latests posts...
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.where(featured: false).includes(:photo).order("published_at DESC").limit(5)

    # ...and photos
    @photos = (can? :manage, Photo) ? Photo.all : Photo.published
    @photos = @photos.order("updated_at DESC").limit(6)
 
    # FIXME: Should check that web doesn't break if there're none of them, i.e. without seed data.   
    fresh_when  etag: [ @highlights,
                        @posts,
                        @photos]
  end
end
