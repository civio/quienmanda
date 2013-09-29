class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  # GET /people
  # GET /people.json
  def index
    @title = 'Personas'
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
    @people = @people.order("updated_at DESC").page(params[:page]).per(16)
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    @title = @person.short_or_long_name
    @relations = (can? :manage, Entity) ? @person.relations : @person.relations.published

    # Facebook Open Graph metadata
    @fb_description = @person.description unless @person.description.blank?
    @fb_image_url = @person.avatar.url() unless @person.avatar.nil?
  end

  private
    def set_person
      @person = Entity.people.find_by_slug(params[:id])
    end
end
