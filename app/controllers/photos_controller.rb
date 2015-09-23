class PhotosController < ApplicationController
  before_action :set_title
  before_action :set_photo, only: [:show, :next, :previous]

  etag { can? :manage, Photo } # Don't cache admin content together with the rest

  layout proc { |controller| controller.request.params[:widget].blank? ? 'application' : 'widget' }

  # GET /photos
  # GET /photos.json
  def index
    @photos = (can? :manage, Photo) ? Photo.all :
              (current_user.nil?) ? Photo.published.validated : Photo.published.authored_by_user( current_user.id )

    if stale?(last_modified: @photos.maximum(:updated_at), :public => current_user.nil?)
      respond_to do |format|
        format.html do
          @photos = @photos.order("updated_at DESC").page(params[:page]).per(15)
        end
        # For JSON API render all photos if there is no 'page' param
        format.json do
          if params[:page].blank?
            @photos = @photos.order("updated_at DESC")
          else
            @photos = @photos.order("updated_at DESC").page(params[:page]).per(15)
          end
        end
      end
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

      # Twitter Photo Card metadata
      @tw_card_photo = @fb_image_url
    end
  end

  # POST /photos/
  def create
    @photo = Photo.new(photo_params)
    @photo.published = true
    @photo.validated = false

    if @photo.save
      # Handle a successful save.
      flash.now[:alert] = "Tu foto se ha enviado con éxito. Te avisaremos cuando la validemos y la hagamos visible para todos los usuarios."
      render :show
    else
      flash[:alert] = "Ha habido un problema en el envío de tu foto. Prueba de nuevo más tarde."
      redirect_to photos_path()
    end
  end

  def next
    photos = (can? :manage, Photo) ? Photo.all : Photo.published
    next_photo = photos.next(@photo).first
    redirect_to next_photo.nil? ? photos_path() : photo_path(next_photo)
  end

  def previous
    photos = (can? :manage, Photo) ? Photo.all : Photo.published
    previous_photo = photos.previous(@photo).first
    redirect_to previous_photo.nil? ? photos_path() : photo_path(previous_photo)
  end

  # GET /photos/tagged/juicy
  # Note: admin only (for now at least)
  def tagged
    authorize! :manage, Photo
    @photos = Photo.tagged_with(params[:tag_name]).page(params[:page]).per(15)
    render :index
  end

  # POST /photos/id/vote-up
  def vote_up
    photo = Photo.find(params[:id])
    if stale?(photo, :public => current_user.nil?)
      photo.liked_by current_user
      respond_to do |format|
        msg = { :status => "ok", :votes => photo.get_likes.size }
        format.json  { render :json => msg }
      end
    end
  end

  # POST /photos/id/vote-down
  def vote_down
    photo = Photo.find(params[:id])
    if stale?(photo, :public => current_user.nil?)
      photo.unliked_by current_user
      respond_to do |format|
        msg = { :status => "ok", :votes => photo.get_likes.size }
        format.json  { render :json => msg }
      end
    end
  end

  private
    def set_photo
      @photo = Photo.includes(:related_entities, :annotations).find(params[:id])
    end

    def set_title
      @title = 'El Fotomandón'
    end

    def photo_params
      params.require(:photo).permit(:author_id, :file, :footer, :copyright, :source)
    end
end
