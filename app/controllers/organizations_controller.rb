class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show]

  etag { current_user }         # Pages vary depending on whether user is logged on
  etag { can? :manage, Entity } # Pages seen as admin may look different

  # GET /organizations
  # GET /organizations.json
  def index
    @title = 'Organizaciones'
    @organizations = (can? :manage, Entity) ? Entity.organizations : Entity.organizations.published
    if stale?(etag: @organizations)
      respond_to do |format|
        format.html do
          @organizations = @organizations.order("updated_at DESC").page(params[:page]).per(12)
        end
        # For JSON API render all photos if there is no 'page' param
        format.json do
          if params[:page].blank?
            @organizations = @organizations.order("updated_at DESC")
          else
            @organizations = @organizations.order("updated_at DESC").page(params[:page]).per(12)
          end
        end
      end
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize! :read, @organization
    if stale?(@organization)
      @title = @organization.short_or_long_name
      @relations = (can? :manage, Entity) ? @organization.relations : @organization.relations.published
      # Order relations both by date at and by date from
      @relations = @relations.order("greatest(relations.from, relations.at) asc")
      
      @related_topics = Topic.find_all_by_slug( @organization.tag_list )

      # Facebook Open Graph metadata
      @fb_description = @organization.description unless @organization.description.blank?
      @fb_image_url = @organization.avatar.url() unless @organization.avatar.nil?

      # Twitter Summary Card metadata
      @tw_card_summary = @fb_description
      @tw_card_photo = @fb_image_url
    end
  end

  private
    def set_organization
      @organization = Entity.organizations
                            .includes(:related_posts, :related_photos, :mentions)
                            .find_by_slug!(params[:id])
    end
end
