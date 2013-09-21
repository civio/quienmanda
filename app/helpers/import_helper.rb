module ImportHelper
  def create_entity_button(name)
    link_to raw('<span class="label"><i class="icon-copy"></i> Create</span>'),
            rails_admin.new_path(model_name: 'Entity', 'entity[name]' => name ), 
            target: '_blank'
  end

  def display_imported_entity(name)
    "#{name} <span class='import-actions'>#{create_entity_button(name)}</span>".html_safe
  end

  # Return the CSS class matching the severity/confidence of a given match
  def match_severity(import_name, matched_entity, score)
    matched_entity ? 
      (score==-1 ? 'warning' : 'success') : 
      'error'
  end
end
