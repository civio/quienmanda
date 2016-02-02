class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  etag { current_user }         # Pages vary depending on whether user is logged on
  etag { can? :manage, Entity } # Pages seen as admin may look different

  # GET /people
  # GET /people.json
  def index
    @title = 'Personas'
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
    if stale?(etag: @people)
      respond_to do |format|
        format.html do
          @people = @people.order("updated_at DESC").page(params[:page]).per(12)
        end
        # For JSON API render all photos if there is no 'page' param
        format.json do
          if params[:page].blank?
            @people = @people.order("updated_at DESC")
          else
            @people = @people.order("updated_at DESC").page(params[:page]).per(12)
          end
        end
      end
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    if stale?(@person)
      @title = @person.short_or_long_name
      @relations = (can? :manage, Entity) ? @person.relations : @person.relations.published
      # Order relations both by date at and by date from
      @relations = @relations.order("greatest(relations.from, relations.at) asc")

      @related_topics = Topic.find_all_by_slug( @person.tag_list )

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
