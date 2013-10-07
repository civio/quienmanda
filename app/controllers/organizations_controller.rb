class OrganizationsController < ApplicationController
  caches_action :index, :show, expires_in: 1.hour, unless: :current_user

  before_action :set_organization, only: [:show]

  # GET /organizations
  # GET /organizations.json
  def index
    @title = 'Organizaciones'
    @organizations = (can? :manage, Entity) ? Entity.organizations : Entity.organizations.published
    @organizations = @organizations.order("updated_at DESC").page(params[:page]).per(16)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize! :read, @organization
    @title = @organization.short_or_long_name
    @relations = (can? :manage, Entity) ? @organization.relations : @organization.relations.published

    # Facebook Open Graph metadata
    @fb_description = @organization.description unless @organization.description.blank?
    @fb_image_url = @organization.avatar.url() unless @organization.avatar.nil?
  end

  private
    def set_organization
      @organization = Entity.organizations.find_by_slug!(params[:id])
    end
end
