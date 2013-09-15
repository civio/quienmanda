class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Add extra parameters to the basic Devise user registration
  # See https://github.com/plataformatec/devise#strong-parameters
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Handle unauthorized access to the admin interface
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    # Force Admin locale to English
    I18n.locale = :en if is_a?(RailsAdmin::ApplicationController)
  end

  # Network graph visualization
  # TODO: Very early times for this. Will eventually be refactored somewhere else
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
