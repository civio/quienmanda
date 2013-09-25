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

    Rails.application.routes.url_helpers.tap do |router|
      extractors = [
        { prefix: router.people_path, method: ->(slug) { Entity.find_by_slug(slug) } },
        { prefix: router.organizations_path, method: ->(slug) { Entity.find_by_slug(slug) } },
        { prefix: router.posts_path, method: ->(slug) { Post.find_by_slug(slug) } }
      ]
      @related_entities = []
      @related_posts = []
      @post.extract_references(get_domain_name, extractors).each do |reference|
        if reference.class.name == 'Entity'
          @related_entities << reference
        else
          @related_posts << reference
        end
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
