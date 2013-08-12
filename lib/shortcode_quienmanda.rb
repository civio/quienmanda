require 'shortcodes/handler'

module Shortcodes
  class QuienManda < Handler

    def url
      shortcode.attributes.fetch('url')
    end

    def text
      fallback = URI(url).path.split('/').last
      shortcode.attributes.fetch('text', fallback)
    end

    def render
      template = <<TEMPLATE
  <a href="#{url}" target="_blank">#{text}</a>
TEMPLATE
      template.strip
    end

    Shortcodes.register_shortcode('qm', self)
    Shortcodes.register_shortcode('quienmanda', self)
  end
end
