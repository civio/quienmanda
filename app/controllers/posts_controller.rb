require 'shortcodes/all'  # Needed (for now) to handle the built-in shortcodes

class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  etag { can? :manage, Post } # Don't cache admin content together with the rest

  # GET /posts
  # GET /posts.json
  def index
    @title = 'Artículos'
    @posts = (can? :manage, Post) ? Post.all : Post.published
    if stale?(last_modified: @posts.maximum(:published_at), :public => current_user.nil?)
      @posts = @posts.order("published_at DESC").includes(:photo).page(params[:page]).per(9)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :read, @post
    if stale?(@post, :public => current_user.nil?)
      @title = @post.title

      # Get related entities and posts from content
      # Note: I used to check that we weren't leaking unpublished related articles 
      # or entities at this point, but it makes no sense: if there's a mention in the
      # article content (i.e. a link in the text) we are leaking whether we show
      # the mentionee in the sidebar or not.
      @related_entities = []
      @related_posts = []
      @post.mentions_in_content.each do |mention|
        mentionee = mention.mentionee
        if mentionee.class.name == 'Entity'
          @related_entities << mentionee
        elsif mentionee.class.name == 'Post'
          @related_posts << mentionee
        end
        # No point in keeping track of mentioned photos, I think.
      end

      # Add the other related posts, the ones that are linking to this one post.
      # We need to check we are not leaking unpublished content at this point.
      @post.related_posts.each do |post|
        next unless post.published? or can? :manage, @post
        @related_posts << post unless @related_posts.include? post
      end

      # Sort related entities so they are displayed properly in sidebar
      @related_entities.sort_by! &:priority

      # Parse shortcodes
      @content = Shortcodes.shortcode(@post.content)

      # Facebook Open Graph metadata
      @fb_description = @post.lead unless @post.lead.blank?
      @fb_image_url = @post.photo.file.url(:full) unless @post.photo.nil? or @post.photo.file.nil?
    end
  end

  # See http://stackoverflow.com/a/4832591
  def feed
    @title = "Artículos de Quién Manda"
    @posts = Post.order("published_at desc").limit(10)
    @updated = @posts.first.updated_at unless @posts.empty?

    respond_to do |format|
      format.atom { render :layout => false }
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end

  private
    def set_post
      @post = Post.includes(:mentions).find_by_slug!(params[:id])
    end

    def get_domain_name
      ENV['DOMAIN_NAME'].blank? ? request.domain : ENV['DOMAIN_NAME']
    end
end
