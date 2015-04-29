class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  etag { can? :manage, Entity } # Don't cache admin content together with the rest

  # GET /people
  # GET /people.json
  def index
    @title = 'Personas'
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
    if stale?(last_modified: @people.maximum(:updated_at), :public => current_user.nil?)
      @people = @people.order("updated_at DESC").page(params[:page]).per(12)
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    if stale?(@people, :public => current_user.nil?)
      @title = @person.short_or_long_name
      @relations = (can? :manage, Entity) ? @person.relations : @person.relations.published
      @relations = @relations.order("relations.from ASC")

      # Facebook Open Graph metadata
      @fb_description = @person.description unless @person.description.blank?
      @fb_image_url = @person.avatar.url() unless @person.avatar.nil?

      # Twitter Summary Card metadata
      @tw_card_summary = @fb_description
      @tw_card_photo = @fb_image_url
    end
  end

  private
    def set_person
      @person = Entity.people
                      .includes(:related_posts, :related_photos, :mentions)
                      .find_by_slug!(params[:id])
    end
end
