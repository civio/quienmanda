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
  # TODO: Test this!
  def match_severity(import_name, matched_entity, score)
    # If there's no match, the result is clear...
    return 'error' if matched_entity.nil?

    # Also if the entity was created during import, needs double checking...
    return 'warning' if score == -1

    # When we have an apparently successful match is when we want to pay more
    # attention sometimes, since the fuzzy matching can be a bit too agressive.
    # Remove accented characters and downcase...
    source = import_name.to_ascii.downcase
    target = matched_entity.short_or_long_name.to_ascii.downcase
    # We could check both short _and_ long name, but don't think would add anything

    # ...and then mark as ok the obvious cases.
    # At this point we could do more sofisticated stuff, like converting the strings
    # into 'bags of words' and checking whether one is included in the other (allowing
    # thus for words out of order, or additional middle names), or return success if
    # score > .9 for example, but this is a trivial approximation that works well.
    if target.include? source or source.include? target
      return 'success'
    end
    return 'warning'  # Be careful with this match
  end
end
