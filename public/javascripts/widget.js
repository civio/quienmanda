jQuery.noConflict();

var $photo,
	embeded;

// Store embeded object to resize on resize
function setupWidget( _embeded ){
	embeded = _embeded;
}

jQuery(document).ready(function($){

	$photo = $('#photo');

	// Setup Annotorious
	anno.setProperties({ hi_stroke: '#6bb21b', });
	anno.addHandler('onMouseOverAnnotation', onAnnoHover);
	anno.addPlugin('RESTStorage', {
		base_url: '/photos/'+$photo.data('photoid')+'/annotations',
		read_only: $photo.data('readonly')
	});

	// On Resize handler 
	$(window).bind("resize", function(){

		anno.reset();
        anno.addPlugin('RESTStorage', {
          base_url: '/photos/'+$photo.data('photoid')+'/annotations',
          read_only: $photo.data('readonly')
        });
        $('.annotorious-es-plugin-load-outer').hide();

        embeded.sendHeight();
	});

	// On Annotorious Mouse Over Handler
    function onAnnoHover(e) {
      if( e.K === undefined ) return true;

      var $annoPopup = $('.annotorious-popup');

      // Align title right if its placed at the right half of the picture
      if( e.K.shapes[0].geometry.x > 0.5 ){
        $annoPopup.css('left', $annoPopup.position().left - $annoPopup.width() - 16 + (e.K.shapes[0].geometry.width*$('.annotorious-annotationlayer').width()) );
      }

      if( $photo.data('readonly') ){
        $('.annotorious-popup-buttons').remove(); // Hide edit buttons if is read only
      }
    }

	/*
	// This is needed only for the widget, but doesn't bother us in the main app, so...
	imagesLoaded( document.getElementById('photo'), function( instance ) {
		anno.makeAnnotatable(document.getElementById('photo'));
	});
	*/
});