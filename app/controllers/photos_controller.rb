class PhotosController < ApplicationController
  before_action :set_photo, only: [:show]

  # GET /photos
  # GET /photos.json
  def index
    @photos = (can? :manage, Photo) ? Photo.all : Photo.published
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    authorize! :read, @photo
  end

  # GET /photos/tagged/juicy
  # Note: admin only (for now at least)
  def tagged
    authorize! :manage, Photo
    @photos = Photo.tagged_with(params[:tag_name])
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end
end
