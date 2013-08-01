class PostsController < ApplicationController
  load_and_authorize_resource find_by: :slug
  
  before_action :set_post, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.published
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.published.find_by_slug(params[:id])
    end
end
