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

      template = <<TEMPLATE
<div id="quienmanda-embed-#{photo_id}" class="quienmanda-embed-wrapper"></div>
<script type="text/javascript" src="/javascripts/pym.min.js"></script>
<script>var pymParent = new pym.Parent('quienmanda-embed-#{photo_id}', '#{url}?widget=1', {});</script>
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
      # Get entity id to uniquely identify each embed
      url =~ /entities\/([^?]*)/
      entity_id = $1

      unless url.include? "?widget=1"
      template = <<TEMPLATE
<div id="quienmanda-embed-viz-#{entity_id}" class="quienmanda-embed-viz" data-url="#{url}?widget=1"></div>
<script async src="/javascripts/widget-viz.js" charset="utf-8"></script>
TEMPLATE
      template
      else
      template = <<TEMPLATE
<div id="quienmanda-embed-viz-#{entity_id}" class="quienmanda-embed-viz" data-url="#{url}"></div>
<script async src="/javascripts/widget-viz.js" charset="utf-8"></script>
TEMPLATE
      template
      end
    end

    Shortcodes.register_shortcode('qmviz', self)
    Shortcodes.register_shortcode('quienmandaviz', self)
  
  end

end
