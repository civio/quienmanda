# A very basic JSON-only controller, custom built for Annotorious storage
class AnnotationsController < ApplicationController
  before_action :set_annotation, only: [:show, :edit, :update, :destroy]

  # GET /annotations.json
  def index
    @annotations = Annotation.all
  end

  # GET /annotations/1.json
  def show
  end

  # GET /annotations/new
  def new
    @annotation = Annotation.new
  end

  # GET /annotations/1/edit
  def edit
  end

  # POST /annotations.json
  def create
    @annotation = Annotation.new(annotation_params)

    respond_to do |format|
      if @annotation.save
        format.json { render action: 'show', status: :created, location: @annotation }
      else
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /annotations/1.json
  def update
    respond_to do |format|
      if @annotation.update(annotation_params)
        format.json { head :no_content }
      else
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1.json
  def destroy
    @annotation.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # TODO: I'm overriding this method to different pre-processing, not the cleanest way.
    def annotation_params
      # Check http://blog.sensible.io/2013/08/17/strong-parameters-by-example.html
      # FIXME params.require(:annotation).permit(:resource_uri, :text)

      # Put all the incoming Annotorious-specific data in a field, don't care about details
      processed_params = { 
        data: JSON.dump(params[:annotation])
      }

      # Find out which photo we're annotating
      path = Rails.application.routes.recognize_path(params[:annotation][:context])
      if path[:controller] == 'photos'
        processed_params[:photo_id] = path[:id]
      end

      # Find out which entity the annotation is refering to
      unless params[:annotation][:text].blank? 
        name = params[:annotation][:text]
        processed_params[:entity] = Entity.find_by_short_name(name) 
        processed_params[:entity] = Entity.find_by_name(name) if processed_params[:entity].nil?
      end

      processed_params
    end
end
