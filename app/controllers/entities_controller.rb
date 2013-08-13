# Redirect to the appropriate People or Organizations controller.
# This exists basically so RailsAdmin can do ShowInApp for Entities.
class EntitiesController < ApplicationController
  def show
    entity = Entity.find_by_slug(params[:id])
    redirect_to entity.person? ? person_path(entity) : organization_path(entity)
  end
end
