require 'shortcodes/handler'

module Shortcodes
  class GoogleDocs < Handler

    def url
      url = shortcode.attributes.fetch('url')
    end

    def width
      attributes.fetch('width', 550)
    end

    def height
      attributes.fetch('height', 500)
    end

    def render
      <<TEMPLATE
<iframe width='#{width}' height='#{height}' frameborder='0' src='#{url}'></iframe>
TEMPLATE
    end

    Shortcodes.register_shortcode('gdocs', self)
    Shortcodes.register_shortcode('googledocs', self)
  end
end
