module EntityHelper
  def icon_link(url, icon_name)
    unless url.blank?
      link_to("<i class='icon-fontello-#{icon_name}'></i>".html_safe, url, target: '_blank')
    end
  end
end