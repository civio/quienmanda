require 'shortcodes/all'  # Needed (for now) to handle the built-in shortcodes

class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = (can? :manage, Post) ? Post.all : Post.published
    @posts = @posts.order("updated_at DESC").page params[:page]
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :read, @post

    @related_entities = []
    @related_posts = []
    @related_photos = []
    @post.mentions_in_content.each do |mention|
      mentionee = mention.mentionee
      if mentionee.class.name == 'Entity'
        @related_entities << mentionee
      elsif mentionee.class.name == 'Photo'
        @related_photos << mentionee
      else
        @related_posts << mentionee
      end
    end

    # Parse shortcodes (do this after we've parsed the post looking for QM references)
    @content = Shortcodes.shortcode(@post.content)
  end

  private
    def set_post
      @post = Post.find_by_slug(params[:id])
    end

    def get_domain_name
      ENV['DOMAIN_NAME'].blank? ? request.domain : ENV['DOMAIN_NAME']
    end
end
