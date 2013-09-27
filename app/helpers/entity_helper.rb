module EntityHelper
  def icon_link(url, icon_name)
    unless url.blank?
      link_to("<i class='icon-fontello-#{icon_name}'></i>".html_safe, url, target: '_blank')
    end
  end

  def display_source(via)
    return if via.blank?
    link_to via do
      '<i class="icon-ok"></i>'.html_safe
    end
  end
end