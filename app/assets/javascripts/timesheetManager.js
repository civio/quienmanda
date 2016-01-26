$j = jQuery.noConflict();

function TimesheeManager(selector, selectorContainer, selectorList) {

  var _this = this;

  var $timesheet = $j(selector),
      $timesheetCont = $j(selectorContainer),
      scrollHeight,
      items;


  _this.onResize = function(){
    
    scrollHeight = $timesheet.find('.scale').width() - $timesheetCont.width();

    // Show arrows only if there is horizontal scroll
    if( scrollHeight <= 0 ){
      $timesheetCont.find('.timesheet-arrow').hide();
    } else {
      $timesheetCont.find('.timesheet-arrow').show();
    }
  };

  _this.onScroll = function(){

    // Update Arrows Visibility
    $timesheetCont.find('.timesheet-arrow-left').css('visibility', ($timesheet.scrollLeft() > 0) ? 'visible' : 'hidden' );
    $timesheetCont.find('.timesheet-arrow-right').css('visibility', ($timesheet.scrollLeft() < scrollHeight) ? 'visible' : 'hidden' );
  };

  _this.onClickArrow = function(e){
    var pos = ( $j(this).hasClass('timesheet-arrow-left') ) ? $timesheet.scrollLeft()-$timesheetCont.width() : $timesheet.scrollLeft()+$timesheetCont.width();
    $timesheet.animate({scrollLeft: pos}, 600);
  };

  function setup(selectorList){

    _this.items = [];

    var td, date1, date2, txt;

    $j(selectorList).each(function(){
      td = $j(this).children('td');
      date1 = td.eq(4).html();
      date2 = td.eq(5).html();
      dateAt = td.eq(6).html();
      if( date1 === '' && dateAt === '' ) return;   // skip dates without init date
      // Setup bubble text
      str = ($j(this).hasClass('self'))
        // Setup text for People: relation + to ("presidente/a de Banco Santander")
        ? td.eq(1).html()+' '+td.eq(2).html()
        // Setup text for Organization: from + relation ("Emilio Botín : presidente/a")
        // Remove prepositions at the end of relation (a,al,de,en,para,por)
        : td.eq(0).html().trim()+': '+td.eq(1).html().replace(/ (a|al|de|en|para|por)$/i, '');
    
      if (dateAt !== '') {
        _this.items.push( [dateAt, dateAt, str, 'lorem'] );
      } else {
        date2 = ( date2 !== '' ) ? date2 : 'now';
        _this.items.push( [date1, date2, str, 'lorem'] );
      }
    });

    var firstDate = (_this.items[0]) ? _this.items[0][0].split('-')[0] : _this.items[0];

    var timesheet = new Timesheet(selector.substring(1), firstDate, firstDate, _this.items);

    $timesheetCont.find('.timesheet-arrow').click(onClickArrow);
    $timesheet.scroll(onScroll);
    onResize();
  }

  // Setup Timesheet
  if ($timesheet) {
    setup(selectorList);
  }

  return _this;
}