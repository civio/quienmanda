class PhotosController < ApplicationController
  load_and_authorize_resource find_by: :slug

  before_action :set_photo, only: [:show]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.published
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.published.find_by_slug(params[:id])
    end
end
