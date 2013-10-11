class PhotosController < ApplicationController
  caches_action :index, 
                expires_in: 1.hour, 
                unless: :current_user, 
                cache_path: Proc.new { request.url + (params[:page]||'') }
  caches_action :show, 
                expires_in: 1.hour, 
                unless: :current_user

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

    # Set response headers to allow widget being embedded cross-domain
    # See http://stackoverflow.com/questions/16561066/ruby-on-rails-4-app-not-works-in-iframe
    if params[:widget]
      response.headers['X-Frame-Options'] = 'ALLOWALL'
    end

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
