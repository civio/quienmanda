jQuery.noConflict();

(function($) {

  var $wall,
      $cont,
      contWidth = 0,
      hasPhoto = false,
      hasVis = false,
      graph;

  jQuery(document).ready( function($) {

    $cont = $('body > .container');
    contWidth = $cont.width();
    
    hasPhoto = $('#photo').length > 0;        // check if there is a photo entity
    hasVis = $('#viz-container').length > 0;  // check if there is a visualization


    /* -------------------- Setup home slider --------------------- */
    if ($('#home-slider-list').length) {

      $('#home-slider').carousel('pause');

      $('#home-slider-list .item a').click(function(e){
        e.preventDefault();
        if( $(this).hasClass('active') ) return true;
        $('#home-slider-list .active').removeClass('active');
        $(this).addClass('active');
        $('#home-slider').carousel( parseInt($(this).attr('href').substr(6), 0) );
      });
    }

    /* -------------------- Setup layouts --------------------- */
    $wall = $('#wall, .extra-wall');
    $wall.imagesLoaded(function() {
      $wall.packery({
        itemSelector: '.item',
        columnWidth: $wall.width() / 12
      });
    });

    /* -------------------- Setup visualization --------------- */
    if (hasVis) {
      graph = new NetworkGraph("#viz-container", "#infobox", "#control-history-undo", "#control-history-redo", getUrlParameter('history'));
      graph.loadRootNode( $('#viz-container').data('path') );
      $('#control-fullscreen, #control-fullscreen-exit').click(function() {
        $('#viz-container').toggleClass('fullscreen');
        graph.resize();
        return false;
      });
      $('#control-zoom-in').click(function() { graph.zoomIn(); return false; });
      $('#control-zoom-out').click(function() { graph.zoomOut(); return false; });
      $('#control-zoom-reset').click(function() { graph.zoomReset(); return false; });
      $('#control-history-undo').click(function() { if (!$(this).hasClass('disabled')) { graph.historyUndo(); } return false; });
      $('#control-history-redo').click(function() { if (!$(this).hasClass('disabled')) { graph.historyRedo(); } return false; });
      $('#control-help').click(function() { return false; });
      $('#visualization-controls a').tooltip();

      // Setup Embed Btn
      if ($('#control-embed').length > 0) {
        var embedId = $('#control-embed').attr('href').substring(1);
        $('#control-embed').click(function(e){
          e.preventDefault();
          embedStr = '<iframe src="http://localhost:3000/entities/'+embedId+'?widget=1&history='+graph.getHistoryParams()+'" width="100%" height="456px" scrolling="no" marginheight="0" frameborder="0"></iframe>';
          $('.embed-code').toggle().focus();
          $('.embed-code input').val(embedStr).select();
        });
      }

      // Setup timesheet
      if ($('#entity-timesheet').size() > 0) {

        var items = [];

        $('#relations-list tbody tr.self').each(function(){
          var td = $(this).children('td');
          var date1 = td.eq(4).html();
          var date2 = td.eq(5).html();
          var now = new Date();
          if( date1 === '' ) return;
          date1 = date1.split('-');
          date2 = ( date2 !== '' ) ? date2.split('-') : [now.getFullYear(), now.getMonth()+1];
          items.push( [date1[1]+'/'+date1[0], date2[1]+'/'+date2[0], td.eq(1).html()+' '+td.eq(2).html(), 'lorem'] );
        });

        $('#entity-timesheet').height( 16+28+(items.length*32) );

        new Timesheet('entity-timesheet', 2015, 2015, items);
      }
    }

    /* -------------------- Setup photo --------------------- */
    if (hasPhoto) {
      anno.setProperties({ hi_stroke: '#6bb21b', });
      anno.addHandler('onMouseOverAnnotation', onAnnoHover);
      anno.addHandler('onEditorShown', onAnnoEditorShown);
      anno.addHandler('onAnnotationCreated', onAnnoReload);
      anno.addHandler('onAnnotationUpdated', onAnnoReload);
      anno.addHandler('onAnnotationRemoved', onAnnoReload);
      anno.addPlugin('RESTStorage', {
        base_url: '/photos/'+$('#photo').data('photoid')+'/annotations',
        read_only: $('#photo').data('readonly')
      });

      // Setup Embed Btn
      if ($('.embed-btn').length > 0) {
        var embedId = $('.embed-btn').attr('href').substring(1);
        $('.embed-code input').val('<div id="quienmanda-embed-'+embedId+'"></div><script src="http://quienmanda.es/javascripts/pym.min.js" type="text/javascript"></script><script type="text/javascript">var pymParent = new pym.Parent("quienmanda-embed-'+embedId+'", "http://quienmanda.es/photos/'+embedId+'?widget=1", {});</script>');
        $('.embed-btn').click(function(e){
          e.preventDefault();
          $('.embed-code').toggle().focus();
          $('.embed-code input').select();
        });
      }

      // Vote up/down via ajax
      if ($('.vote-up, .vote-down').length > 0) {
        $('.vote-btn').click( function(e) {
          e.preventDefault();
          var $voteBtn = $(this);
          var action = ($voteBtn.hasClass('vote-up')) ? '/vote-up/' : '/vote-down/';
          $.post( $(this).data('path')+action, function(data) {
            if (data && data.status === 'ok') {
              $voteBtn.find('.vote').html( data.votes );
              if ($voteBtn.hasClass('vote-up')) {
                $voteBtn.removeClass('vote-up').addClass('vote-down');
                $voteBtn.find('.txt').html( 'Ya no me gusta' );
              }
              else{
                $voteBtn.removeClass('vote-down').addClass('vote-up');
                $voteBtn.find('.txt').html( 'Me gusta' );
              }
            }
          });
        });
      }
    }

    // On Annotorious Mouse Over Handler
    function onAnnoHover(e) {
      if (e.K === undefined) return true;

      var $annoPopup = $('.annotorious-popup');

      // Align title right if its placed at the right half of the picture
      if (e.K.shapes[0].geometry.x > 0.5) {
        $annoPopup.css('left', $annoPopup.position().left - $annoPopup.width() - 16 + (e.K.shapes[0].geometry.width*$('.annotorious-annotationlayer').width()) );
      }

      if ($('#photo').data('readonly')) {
        $('.annotorious-popup-buttons').remove(); // Hide edit buttons if is read only
      }
    }

    // On Annotorious Editor is Shown to create a new or edit an existing annotation
    function onAnnoEditorShown(e) {
      var people = null,
          $input = $('.annotorious-editor .annotorious-editor-text'),
          $results = $('<div class="annotorious-autocomplete-results"></div>');

      $('.annotorious-editor').append( $results );

      if (!e) {   // Create new Annotation
        $input.attr('placeholder', 'Añade una persona...');
      } else {    // Edit existing Annotation
        $input.val( e.name );
      }

      // Get .json with all people list
      $.getJSON( '/entities.json', function(data) {
        people = data;
        $input.trigger( 'keyup' );  // force keyup event when entities.json is loaded
      });

      // Listen KeyUp Event
      $input.bind( 'keyup', function(e) {
        var index,
            code = e.keyCode;

        // code == Enter:  select highlighted item
        if (code == 13) {
          if ($results.children().size() > 0) {
            index = $results.children().index( $results.children('.hover') );
            index = (index > 0) ? index : 0;
            $results.children().eq(index).trigger('click');
          }
        }
        // code == up/down arrows: move along items
        else if (code == 40 || code == 38) {
          if ($results.children().size() > 0) {
            index = $results.children().index( $results.children('.hover') );
            $results.children().removeClass('hover');
            index = (code == 38) ? index-1 : index+1;
            if (index >= $results.children().size()) {
              index = 0;
            } else if (index < 0) {
              index = $results.children().size()-1;
            }
            $results.children().eq(index).addClass('hover');
          }
        }
        // code == a letter: do autocomplete
        else {

          if( people === null ) return;

          var filter = $(this).val().toLowerCase();

          // Skip if there's no text
          if (filter.trim() === ''){
            $results.empty();
            return;
          }

          // Filter people
          var peopleFiltered = people.filter( function (val,key) { return (val.name.toLowerCase().indexOf(filter) !== -1 ); });
          $results.empty();
          $.each( peopleFiltered, function( key,val ) {
            $results.append('<a href="#">'+val.name+'</a>');
          });

          // Select suggested Person on click
          $results.find('a').click(function(e){
            e.preventDefault();
            $input.val( $(this).html() ).focus();
            $results.empty();
          });
        }
      });
    }

    // On Annotation changes, reload the page to show the updated info
    function onAnnoReload(e) {
      window.location.reload();
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

    // Get URL Parameters
    function getUrlParameter(sParam)
    {
      var sPageURL = window.location.search.substring(1);
      var sURLVariables = sPageURL.split('&');
      for (var i = 0; i < sURLVariables.length; i++) 
      {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) 
        {
          return sParameterName[1];
        }
      }
    }   
  });


  /* -------------------- Resize --------------------- */
  function onResize(e) {

    if ($cont && contWidth !== $cont.width()) {

      contWidth = $cont.width();

      // Update packery column width
      $wall.packery({
        columnWidth: $wall.width() / 12
      });

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
    else if (hasVis && $('#viz-container').hasClass('fullscreen')) {
      graph.resize();   // always resize when visualization is fullscreen 
    }
  }

})(jQuery);