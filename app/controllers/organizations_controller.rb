class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show]

  etag { can? :manage, Entity } # Don't cache admin content together with the rest

  # GET /organizations
  # GET /organizations.json
  def index
    @title = 'Organizaciones'
    @organizations = (can? :manage, Entity) ? Entity.organizations : Entity.organizations.published
    if stale?(last_modified: @organizations.maximum(:updated_at), :public => current_user.nil?)
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
    if stale?(@organization, :public => current_user.nil?)
      @title = @organization.short_or_long_name
      @relations = (can? :manage, Entity) ? @organization.relations : @organization.relations.published

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
