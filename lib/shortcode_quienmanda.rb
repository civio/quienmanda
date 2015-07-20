require 'shortcodes/handler'

module Shortcodes
  class QuienManda < Handler

    def url
      shortcode.attributes.fetch('url')
    end

    def width
      attributes.fetch('width', 500)
    end

    def render
      # Get photo id to uniquely identify each embed
      url =~ /photos\/(\d+)/
      photo_id = $1

#       template = <<TEMPLATE
# <div id="quienmanda-embed-#{photo_id}" class="quienmanda-embed-wrapper">
# <iframe src="#{url}?widget=1" scrolling="no" marginheight="0" frameborder="0" width="100%" height="450px"></iframe>
# </div>
# TEMPLATE
#       template

      template = <<TEMPLATE
<div id="quienmanda-embed-#{photo_id}" class="quienmanda-embed-wrapper"></div>
<script type="text/javascript" src="/javascripts/pym.min.js"></script>
<script>
    var pymParent = new pym.Parent('quienmanda-embed-#{photo_id}', '#{url}?widget=1', {});
</script>
TEMPLATE
      template

    end

    Shortcodes.register_shortcode('qm', self)
    Shortcodes.register_shortcode('quienmanda', self)
  
  end


  class QuienMandaViz < Handler

    def url
      shortcode.attributes.fetch('url')
    end

    def width
      attributes.fetch('width', 500)
    end

    def render

      unless url.include? "?widget=1"
      template = <<TEMPLATE
<div class="quienmanda-embed-viz-wrapper">
<iframe src="#{url}?widget=1" scrolling="no" marginheight="0" frameborder="0" width="100%" height="450px"></iframe>
</div>
TEMPLATE
      template
      else
      template = <<TEMPLATE
<div class="quienmanda-embed-viz-wrapper">
<iframe src="#{url}" scrolling="no" marginheight="0" frameborder="0" width="100%" height="450px"></iframe>
</div>
TEMPLATE
      template
      end
    end

    Shortcodes.register_shortcode('qmviz', self)
    Shortcodes.register_shortcode('quienmandaviz', self)
  
  end

end
