require 'shortcodes/all'  # Needed (for now) to handle the built-in shortcodes

class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @title = 'Artículos'
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.order("updated_at DESC").page params[:page]
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :read, @post

    # Get related entities and posts
    @title = @post.title
    @related_entities = []
    @related_posts = @post.related_posts  # As a start
    @post.mentions_in_content.each do |mention|
      mentionee = mention.mentionee
      if mentionee.class.name == 'Entity'
        @related_entities << mentionee
      elsif mentionee.class.name == 'Post'
        @related_posts << mentionee
      end
      # No point in keeping track of mentioned photos, I think.
    end
    @related_entities.sort_by! &:priority

    # Parse shortcodes
    @content = Shortcodes.shortcode(@post.content)

    # Facebook Open Graph metadata
    @fb_description = @post.lead unless @post.lead.blank?
    @fb_image_url = @post.photo.file.url(:full) unless @post.photo.nil? or @post.photo.file.nil?
  end

  private
    def set_post
      @post = Post.find_by_slug(params[:id])
    end

    def get_domain_name
      ENV['DOMAIN_NAME'].blank? ? request.domain : ENV['DOMAIN_NAME']
    end
end
