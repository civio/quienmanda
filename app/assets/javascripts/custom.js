(function($) {

/* ------------------ Back To Top ------------------- */
jQuery(document).ready(function($){

  jQuery('#under-footer-back-to-top a').click(function(){
    jQuery('html, body').animate({scrollTop:0}, 300); 
    return false; 
  });

}); 

/* -------------------- Isotope --------------------- */
/* dcabo: This was called on ready() in the original template, but images overlapped
          when using Turbolinks (only in Firefox, maybe). See discussion at
          https://github.com/rails/turbolinks/issues/159 
/* dcabo: Nah, undo, didn't fix it but broke the search page for some reason. Will
          try something else. */

jQuery(document).ready(function () {
  
  $('#wall').imagesLoaded(function() {
    
    var $container = $('#wall');
    $select = $('#filters select');

    // initialize Isotope
    $container.isotope({
      // options...
      resizable: false, // disable normal resizing
      // set columnWidth to a percentage of container width
      masonry: { columnWidth: $container.width() / 12 }
    });

    // update columnWidth on window resize
    $(window).smartresize(function(){
      $container.isotope({
        // update columnWidth to a percentage of container width
        masonry: { columnWidth: $container.width() / 12 }
      });
    });


    $container.isotope({
      itemSelector : '.item'
    });

    $select.change(function() {
      var filters = $(this).val();
      $container.isotope({
        filter: filters
      });
    });

    var $optionSets = $('#filters .option-set'),
        $optionLinks = $optionSets.find('a');

    $optionLinks.click(function(){      
      var $this = $(this);
      // don't proceed if already selected
      if ( $this.hasClass('selected') ) {
          return false;
      }

      var $optionSet = $this.parents('.option-set');
      $optionSet.find('.selected').removeClass('selected');
      $this.addClass('selected');

      // make option object dynamically, i.e. { filter: '.my-filter-class' }
      var options = {},
          key = $optionSet.attr('data-option-key'),
          value = $this.attr('data-option-value');

      // parse 'false' as false boolean
      value = value === 'false' ? false : value;
      options[ key ] = value;
      if ( key === 'layoutMode' && typeof changeLayoutMode === 'function' ) {
        // changes in layout modes need extra logic
        changeLayoutMode( $this, options )
      } else {
        // otherwise, apply new options
        $container.isotope( options );
      }

      return false;
      });
  });
  
});

/* -------------------- Width Functions --------------------- */

jQuery(document).ready(function($){
  
  widthFunctions();

});

$(window).bind("resize", widthFunctions);

function widthFunctions(e) {
  $=jQuery; /* Strange interactions with Annotorious going on */

  var winHeight = $(window).height();
  var winWidth = $(window).width();

  if (winWidth < 980 && winWidth > 767) {
    
    if($("#wall").width()) {
      
      if($(".item").hasClass("span3")) {

        $(".item").removeClass("span3");
        $(".item").addClass("span4");

      }
      
    }
    
    if($(".lr-page").hasClass("span4 offset4")) {

      
      $(".lr-page").removeClass("span4 offset4");
      $(".lr-page").addClass("span6 offset3");
      
      $("#page-title").removeClass("span4 offset4");
      $("#page-title").addClass("span6 offset3");
    }
            
  } else {
    
    if($("#wall").width()) {
      
      if($(".item").hasClass("span4")) {

        $(".item").removeClass("span4");
        $(".item").addClass("span3");

      }
      
    }
    
    if($(".lr-page").hasClass("span6 offset3")) {
      
      $(".lr-page").removeClass("span6 offset3");
      $(".lr-page").addClass("span4 offset4");
      
      $("#page-title").removeClass("span6 offset3");
      $("#page-title").addClass("span4 offset4");
    }
      
  }
  
}

})(jQuery);