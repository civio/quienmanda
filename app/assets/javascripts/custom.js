(function($) {

/* ------------------ Back To Top ------------------- */
jQuery(document).ready(function($){

  jQuery('#under-footer-back-to-top a').click(function(){
    jQuery('html, body').animate({scrollTop:0}, 300); 
    return false; 
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

jQuery(document).ready(function(){
  layoutPhotoWall('#wall');
  layoutPhotoWall('.extra-wall'); /* Sigh */
});


/* -------------------- Width Functions --------------------- */

jQuery(document).ready(function($){
  
  widthFunctions();

});

$(window).bind("resize", widthFunctions);

function widthFunctions(e) {
  var winHeight = $(window).height();
  var winWidth = $(window).width();

  if (winWidth < 980 && winWidth > 767) {
    
    if($("#wall").width()) {
      if($("#wall.item").hasClass("span3")) {
        $("#wall.item").removeClass("span3");
        $("#wall.item").addClass("span4");
      }      
    }
            
  } else {
    
    if($("#wall").width()) {
      if($(".item").hasClass("span4")) {
        $("#wall.item").removeClass("span4");
        $("#wall.item").addClass("span3");
      }
    }

  }
  
}

/* -------------------- Misc functions --------------------- */

$(function () {

  // Related entities sidebar
  if ( $('.extra-related-entity').length > 0 ) {
    $('#related-entities-toggle').click(function(){
      $('.extra-related-entity').slideToggle();
      $('#related-entities-toggle').hide();
    });
  } else {
    $('#related-entities-toggle').hide();
  };

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

})(jQuery);