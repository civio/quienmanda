class PhotosController < ApplicationController
  before_action :set_title
  before_action :set_photo, only: [:show]

  layout proc { |controller| controller.request.params[:widget].blank? ? 'application' : 'widget' }

  # GET /photos
  # GET /photos.json
  def index
    @photos = (can? :manage, Photo) ? Photo.all : Photo.published
    @photos = @photos.order("updated_at DESC").page(params[:page]).per(15)
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    authorize! :read, @photo

    # Facebook Open Graph metadata
    @fb_description = @photo.footer unless @photo.footer.blank?
    @fb_image_url = @photo.file.url(:full) unless @photo.file.nil?
  end

  # GET /photos/tagged/juicy
  # Note: admin only (for now at least)
  def tagged
    authorize! :manage, Photo
    @photos = Photo.tagged_with(params[:tag_name])
    render :index
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def set_title
      @title = 'El Fotomandón'
    end
end
