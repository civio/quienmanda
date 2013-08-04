require 'shortcodes/handler'

module Shortcodes
  class QuienManda < Handler

    def url
      url = shortcode.attributes.fetch('url')
    end

    def render
    # TODO: Implement this!
      <<TEMPLATE
  <a href="#{url}" target="_blank">Esto es un enlace QuienManda (TO DO)</a>
TEMPLATE
    end

    Shortcodes.register_shortcode('quienmanda', self)
  end
end
