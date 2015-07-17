$j = jQuery.noConflict();

function TimesheeManager(selector, selectorContainer, selectorList) {

  var _this = this;

  var $timesheet = $j(selector),
      $timesheetCont = $j(selectorContainer),
      scrollHeight;


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

    var items = [],
        td, date1, date2, txt;

    $j(selectorList).each(function(){
      td = $j(this).children('td');
      date1 = td.eq(4).html();
      date2 = td.eq(5).html();
      dateAt = td.eq(6).html();
      str = ($j(this).hasClass('self')) ? td.eq(1).html()+' '+td.eq(2).html() : td.eq(0).html()+' '+td.eq(1).html()+' '+td.eq(2).html();
      
      if (dateAt !== '') {
        items.push( [dateAt, dateAt, str, 'lorem'] );
      } else {
        date1 = ( date1 !== '' ) ? date1 : 'nostart';
        date2 = ( date2 !== '' ) ? date2 : 'now';
        items.push( [date1, date2, str, 'lorem'] );
      }
    });

    var firstDate = items[0][0].split('-')[0];

    new Timesheet(selector.substring(1), firstDate, firstDate, items);

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