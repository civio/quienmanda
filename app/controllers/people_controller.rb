class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  # GET /people
  # GET /people.json
  def index
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    @relations = (can? :manage, Entity) ? @person.relations : @person.relations.published
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Entity.people.find_by_slug(params[:id])
    end
end
