require 'shortcodes/handler'

module Shortcodes
  class DocumentCloud < Handler

    def url
      url = shortcode.attributes.fetch('url')
    end

    def document_id
      url =~ /documents\/(\d+)-/
      $1
    end

    def height
      attributes.fetch('height', 700)
    end

    def width
      attributes.fetch('width', 500)
    end

    def document_name
      hyphen_position = url.index('-')
      unless hyphen_position.nil?
        return url[hyphen_position+1..-6]  # -6 to remove the trailing '.html'
      end
    end

    def render
      <<TEMPLATE
<div id="DV-viewer-#{document_id}-#{document_name}" class="DV-container"></div>
<script src="//s3.amazonaws.com/s3.documentcloud.org/viewer/loader.js"></script>
<script>
  DV.load("//www.documentcloud.org/documents/#{document_id}-#{document_name}.js", {
    width: '#{height}',
    height: '#{width}',
    sidebar: false,
    container: "#DV-viewer-#{document_id}-#{document_name}"
  });
</script>
<noscript>
  <a href="http://s3.documentcloud.org/documents/#{document_id}/#{document_name}.pdf" target="_blank">Documento (PDF)</a>
  <br />
  <a href="http://s3.documentcloud.org/documents/#{document_id}/#{document_name}.txt" target="_blank">Documento (Texto)</a>
</noscript>
TEMPLATE
    end

    Shortcodes.register_shortcode('dc', self)
    Shortcodes.register_shortcode('documentcloud', self)
  end
end
