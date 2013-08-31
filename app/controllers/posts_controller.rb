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
    @content = Shortcodes.shortcode(@post.content)

    # FIXME: Remove hardcoded stuff
    extractors = [
      { regex: /^\/people\/(.*)$/, method: ->(slug) { Entity.find_by_slug(slug) } },
      { regex: /^\/organizations\/(.*)$/, method: ->(slug) { Entity.find_by_slug(slug) } }
    ]
    @related_entities = @post.extract_references('qmqm.herokuapp.com', extractors)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_slug(params[:id])
    end
end
