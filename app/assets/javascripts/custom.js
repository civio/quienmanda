jQuery.noConflict();

(function($) {

  var $cont, contWidth = 0,
      hasPhoto = false,
      hasVis = false,
      graph;

  jQuery(document).ready(function($){

    $cont = $('body > .container');
    contWidth = $cont.width();
    
    hasPhoto = $('#photo').length > 0;        // check if there is a photo entity
    hasVis = $('#viz-container').length > 0;  // check if there is a visualization

    /* -------------------- Setup layouts --------------------- */
    layoutPhotoWall('#wall');
    layoutPhotoWall('.extra-wall'); /* Sigh */

    /* -------------------- Setup visualization --------------- */
    if( hasVis ){
      graph = new NetworkGraph("#viz-container", "#infobox");
      graph.loadNode( $('#viz-container').data('path') );
      $('#control-fullscreen, #control-fullscreen-exit').click(function() {
        $('#viz-container').toggleClass('fullscreen');
        graph.resize();
        return false;
      });
      $('#control-zoom-in').click(function() { graph.zoomIn(); return false; });
      $('#control-zoom-out').click(function() { graph.zoomOut(); return false; });
      $('#control-zoom-reset').click(function() { graph.zoomReset(); return false; });
      $('#control-help').click(function() { return false; });
      $('#visualization-controls a').tooltip();
    }

    /* -------------------- Setup photo --------------------- */
    if( hasPhoto ){
      anno.setProperties({ hi_stroke: '#6bb21b', });
      if( $('#photo').data('readonly') ){
        anno.addHandler('onMouseOverAnnotation', function(e) {
          $('.annotorious-popup-buttons').remove(); // Hide edit buttons if is read only
        });
      }
      anno.addPlugin('RESTStorage', {
        base_url: '/photos/'+$('#photo').data('photoid')+'/annotations',
        read_only: $('#photo').data('readonly')
      });
    }


    /* -------------------- Setup Resize --------------------- */
    onResize();
    $(window).bind("resize", onResize);


    /* -------------------- Misc functions ------------------- */

    // Back to Top
    $('#under-footer-back-to-top a').click(function(){
      $('html, body').animate({scrollTop:0}, 300);
      return false;
    });

    // Related entities sidebar
    if ( $('.extra-related-entity').length > 0 ) {
      $('#related-entities-toggle').click(function(){
        $('.extra-related-entity').slideToggle();
        $('#related-entities-toggle').hide();
      });
    } else {
      $('#related-entities-toggle').hide();
    }

    // Label toggling on/off 
    $('.label.toggable').click(function() {
      $(this).toggleClass('active, inactive');
    });

    // FooTable
    $('.footable').footable();

    // Newsletter subscription
    $('#mce-EMAIL, #mce-EMAIL-footer').click(function() {
      $(this).val('');
      $(this).css('border', 'none');
    });

  });


  /* -------------------- Isotope --------------------- */
  function layoutPhotoWall(container_name) {
    $(container_name).imagesLoaded(function() {
      
      var $container = $(container_name);
      $container.isotope({
        // options...
        resizable: false, // disable normal resizing
        // set columnWidth to a percentage of container width
        masonry: { columnWidth: $container.width() / 12 },
        itemSelector : '.item'
      });

      // update columnWidth on window resize
      $(window).smartresize(function(){
        $container.isotope({
          // update columnWidth to a percentage of container width
          masonry: { columnWidth: $container.width() / 12 }
        });
      });
    });
  }

  /* -------------------- Resize --------------------- */
  function onResize(e) {
   
    // Reset Annotorious when change container width
    if ($cont && contWidth !== $cont.width()) {
      contWidth = $cont.width();

      // Reset Annotorious
      if (hasPhoto) {
        anno.reset();
        anno.addPlugin('RESTStorage', {
          base_url: '/photos/'+$('#photo').data('photoid')+'/annotations',
          read_only: $('#photo').data('readonly')
        });
        $('.annotorious-es-plugin-load-outer').hide();
      }

      // Resize visualization
      if (hasVis) {
        graph.resize();
      }
    }
  }

})(jQuery);