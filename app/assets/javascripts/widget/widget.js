// This is a manifest file that'll be compiled into widget.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require ../jquery.imagesloaded.js
//= require ./pym.min.js
//= require_directory ../annotorious

jQuery.noConflict();

var $photo,
    embeded;

jQuery(document).ready(function($) {
  embeded = new pym.Child();

  $photo = $('#photo');

  imagesLoaded( $photo, function( instance ) {
    anno.makeAnnotatable(document.getElementById('photo'));

    // Setup Annotorious
    anno.setProperties({ hi_stroke: '#6bb21b', });
    anno.addHandler('onMouseOverAnnotation', onAnnoHover);
    anno.addPlugin('RESTStorage', {
      base_url: '/photos/'+$photo.data('photoid')+'/annotations',
      read_only: $photo.data('readonly')
    });

    embeded.sendHeight();
    $(window).bind("resize", onResizeHandler);
  });

  // On Resize handler 
  function onResizeHandler() {
    anno.reset();
    anno.addPlugin('RESTStorage', {
      base_url: '/photos/'+$photo.data('photoid')+'/annotations',
      read_only: $photo.data('readonly')
    });
    $('.annotorious-es-plugin-load-outer').hide();

    embeded.sendHeight();
  }

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
});