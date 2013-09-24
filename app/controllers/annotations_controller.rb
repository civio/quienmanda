# JSON only
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
    def annotation_params
      # Check http://blog.sensible.io/2013/08/17/strong-parameters-by-example.html
      # FIXME params.require(:annotation).permit(:resource_uri, :text)
      { data: params[:annotation] }
    end
end
