# Redirect to the appropriate People or Organizations controller.
# This exists basically so RailsAdmin can do ShowInApp for Entities.
class EntitiesController < ApplicationController
  def show
    entity = Entity.find_by_slug(params[:id])
    respond_to do |format|
      format.html do
        redirect_to entity.person? ? person_path(entity) : organization_path(entity)
      end
      # TODO: I should change the JS client to use just the plain show/ action
      # returning JSON, but for now a custom method is needed...
      format.json do
        authorize! :read, entity
        relations = (can? :manage, Entity) ? entity.relations : entity.relations.published
        render json: generate_graph_data(entity, relations)
      end
    end
  end

  private
  # Network graph visualization
  # TODO: Very early times for this. Will eventually be refactored somewhere else
  def add_node_if_needed(nodes, entity, root: false)
    if nodes[entity.id].nil?
      nodes[entity.id] = { 
        name: entity.name, 
        group: entity.person? ? 1 : 2, 
        url: entity_path(entity, format: :json)
      }
      # Should the node be fixed to the center of the screen?
      nodes[entity.id][:root] = true if root
    end
  end

  def generate_graph_data(root_entity, relations)
    nodes = {}
    links = []

    # Add the root node in advance, to mark it as fixed
    add_node_if_needed(nodes, root_entity, root: true)

    # Add all the given relations to the network graph
    relations.each do |relation|
      add_node_if_needed(nodes, relation.source)
      add_node_if_needed(nodes, relation.target)
      links << { 
        source: entity_path(relation.source, format: :json),
        target: entity_path(relation.target, format: :json),
        id: relation.id,
        value: 9  # Nice thick link
      }
    end
    { nodes: nodes.values, links: links }
  end  
end
