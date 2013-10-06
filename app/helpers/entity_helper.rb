module EntityHelper
  # Used to display social networks links
  def icon_link(url, icon_name)
    unless url.blank?
      link_to("<i class='icon-fontello-#{icon_name}'></i>".html_safe, absolute_url(url), target: '_blank')
    end
  end

  def display_source(via)
    return if via.blank?
    link_to absolute_url(via), target: '_blank' do
      '<i class="icon-ok"></i>'.html_safe
    end
  end
end