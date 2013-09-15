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
    @graph_data = generate_graph_data(@relations)
  end

  private
    def set_person
      @person = Entity.people.find_by_slug(params[:id])
    end

    # Very early times for this. Will eventually be refactored somewhere else
    def generate_graph_data(relations)
      nodes = {}
      links = []
      relations.each do |relation|
        if nodes[relation.source.id].nil?
          nodes[relation.source.id] = { name: relation.source.name, group: 1, node_id: nodes.size }
        end
        if nodes[relation.target.id].nil?
          nodes[relation.target.id] = { name: relation.target.name, group: 1, node_id: nodes.size }
        end

        links << { 
          source: nodes[relation.source.id][:node_id],
          target: nodes[relation.target.id][:node_id],
          value: 9
        }
      end
      { nodes: nodes.values, links: links }
    end
end
