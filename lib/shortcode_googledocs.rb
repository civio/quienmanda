require 'shortcodes/handler'

module Shortcodes
  class DocumentCloud < Handler

    def url
      url = shortcode.attributes.fetch('url')
    end

    def height
      attributes.fetch('height', 700)
    end

    def width
      attributes.fetch('width', 500)
    end

    def render
      <<TEMPLATE
<iframe width='500' height='300' frameborder='0' src='#{url}'></iframe>
TEMPLATE
    end

    Shortcodes.register_shortcode('gdocs', self)
    Shortcodes.register_shortcode('googledocs', self)
  end
end
