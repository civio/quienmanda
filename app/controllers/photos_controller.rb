class PhotosController < ApplicationController
  before_action :set_title
  before_action :set_photo, only: [:show]

  etag { can? :manage, Photo } # Don't cache admin content together with the rest

  layout proc { |controller| controller.request.params[:widget].blank? ? 'application' : 'widget' }

  # GET /photos
  # GET /photos.json
  def index
    @photos = (can? :manage, Photo) ? Photo.all : Photo.published
    if stale?(last_modified: @photos.maximum(:updated_at), :public => current_user.nil?)
      @photos = @photos.order("updated_at DESC").page(params[:page]).per(15)
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    authorize! :read, @photo
    if stale?(@photo, :public => current_user.nil?)
      # Set response headers to allow widget being embedded cross-domain
      # See http://stackoverflow.com/questions/16561066/ruby-on-rails-4-app-not-works-in-iframe
      if params[:widget]
        response.headers['X-Frame-Options'] = 'ALLOWALL'
      end

      # Facebook Open Graph metadata
      @fb_description = @photo.footer unless @photo.footer.blank?
      @fb_image_url = @photo.file.url(:full) unless @photo.file.nil?
    end
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
