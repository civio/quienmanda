class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  # GET /people
  # GET /people.json
  def index
    @people = (can? :manage, Entity) ? Entity.people : Entity.people.published
    @people = @people.order("updated_at DESC").page(params[:page]).per(16)
  end

  # GET /people/1
  # GET /people/1.json
  def show
    authorize! :read, @person
    @relations = (can? :manage, Entity) ? @person.relations : @person.relations.published
    @graph_data = generate_graph_data(@person, @relations)
  end

  private
    def set_person
      @person = Entity.people.find_by_slug(params[:id])
    end

    # Network graph visualization
    def add_node_if_needed(nodes, entity, root: false)
      if nodes[entity.id].nil?
        nodes[entity.id] = { 
          name: entity.name, 
          group: entity.person? ? 1 : 2, 
          node_id: nodes.size,
          root: root  # Should the node be fixed to the center of the screen?
        }
      end
    end

    # TODO: Very early times for this. Will eventually be refactored somewhere else
    def generate_graph_data(root_entity, relations)
      nodes = {}
      links = []

      # Add the root node in advance, to make sure it's marked as fixed
      add_node_if_needed(nodes, root_entity, root: true)

      # Add all the given relations to the network graph
      relations.each do |relation|
        add_node_if_needed(nodes, relation.source)
        add_node_if_needed(nodes, relation.target)
        links << { 
          source: nodes[relation.source.id][:node_id],
          target: nodes[relation.target.id][:node_id],
          value: 9  # Nice thick link
        }
      end
      { nodes: nodes.values, links: links }
    end
end
