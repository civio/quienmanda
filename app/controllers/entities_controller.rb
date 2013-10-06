include ApplicationHelper

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
        name: entity.short_or_long_name,
        description: entity.description,
        group: entity.person? ? 1 : 2, 
        url: entity_path(entity)
      }
      # Should the node be fixed to the center of the screen?
      nodes[entity.id][:root] = true if root
    end
  end

  def relation_as_hash(relation)
    { 
      id: relation.id,
      source: entity_path(relation.source),
      target: entity_path(relation.target),
      type: relation.relation_type.description,
      via: relation.sources.map{|s| absolute_url(s) },
      from: relation.from,
      to: relation.to,
      at: relation.at
    }
  end

  def add_child_relations(links, node)
    node.relations.each do |relation|
      links[relation.id] = relation_as_hash(relation)
    end
  end

  def generate_graph_data(root_entity, relations)
    nodes = {}
    links = {}
    child_links = {}

    # Add the root node in advance, to mark it as fixed
    add_node_if_needed(nodes, root_entity, root: true)

    # Add all the given relations to the network graph
    relations.each do |relation|
      add_node_if_needed(nodes, relation.source)
      add_node_if_needed(nodes, relation.target)
      links[relation.id] = relation_as_hash(relation)

      # In order for the visualization to be able to show among the newly added child nodes
      # (and not just from the root node to them) we need to retrieve their relations.
      # We could try to find the sibling relations in the server and return just those, but
      # we don't know which other nodes exist already in the visualization (which gets
      # built interactively), so we need to send the whole thing back to the client.
      add_child_relations(child_links, relation.source) unless root_entity==relation.source
      add_child_relations(child_links, relation.target) unless root_entity==relation.target
    end
    { nodes: nodes.values, links: links.values, child_links: child_links.values }
  end  
end
