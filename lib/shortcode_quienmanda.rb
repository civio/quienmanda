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

      # See http://stackoverflow.com/a/15558627
      template = <<TEMPLATE
<div class="quienmanda-embed-wrapper">
<script>
  // Create IE + others compatible event handler
  var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
  var eventer = window[eventMethod];
  var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

  // Listen to message from child window
  eventer(messageEvent, function(event) {
    if ('#{url}'.indexOf(event.origin) == 0) {
      document.getElementById("quienmanda-embed-"+event.data.id).height = event.data.height + 'px';
    }
  },false);
</script>
<iframe class="quienmanda-embed" id="quienmanda-embed-#{photo_id}" frameborder="0" width="#{width}"
  style="display: block; border-style: solid; border-color: #FAFAFA; border-radius: 4px 4px 4px 4px; border-right: 1px solid #FAFAFA; border-width: 2px 1px 1px; margin: 10px auto; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15), 0 2px 1px rgba(0, 0, 0, 0.1), 0 3px 1px rgba(0, 0, 0, 0.05);"
  height="0" scrolling="no" src="#{url}?widget=1">
</iframe>
</div>
TEMPLATE
      template
    end

    Shortcodes.register_shortcode('qm', self)
    Shortcodes.register_shortcode('quienmanda', self)
  end
end
