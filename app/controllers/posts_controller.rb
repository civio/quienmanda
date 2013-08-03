class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = (can? :manage, Post) ? Post.all : Post.published
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :read, @post
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_slug(params[:id])
    end
end
