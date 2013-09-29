module ApplicationHelper
  # Used on search page to pick correct helper
  def partial_name(thing)
    case thing.class.to_s
    when 'Post'
      return '/shared/show_post'
    when 'Entity'
      return thing.person? ? '/shared/show_person' : '/shared/show_organization'
    when 'Photo'
      return '/shared/show_photo'
    end
    nil # Shouldn't happen
  end

  # Make sure links to external sites (like photo credits) are absolute
  def absolute_url(url)
    url.start_with?('http') ? url : "http://#{url}"
  end
end
