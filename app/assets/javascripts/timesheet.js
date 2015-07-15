/* global TimesheetBubble */

(function() {
  'use strict';

  /**
   * Initialize a Timesheet
   */
  var Timesheet = function(container, min, max, data) {
    this.data = [];
    this.year = {
      min: min,
      max: max,
    };

    this.parse(data || []);

    if (typeof document !== 'undefined') {
      this.container = (typeof container === 'string') ? document.querySelector('#'+container) : container;
      this.drawSections();
      this.insertData();
    }
  };

  /**
   * Insert data into Timesheet
   */
  Timesheet.prototype.insertData = function() {
    var html = [];
    var widthMonth = this.container.querySelector('.scale section').offsetWidth;
    var middleYear = this.year.min+((this.year.max-this.year.min)*0.5);
    var cur, bubble, lineClass, line;

    for (var n = 0, m = this.data.length; n < m; n++) {
      cur = this.data[n];
      bubble = new Bubble(widthMonth, this.year.min, cur.start, cur.end);

      lineClass = (bubble.end && bubble.end.isNow) ? ' class="now"' : '';
      line = [
        '<span style="width: ' + bubble.getWidth() + 'px" class="bubble bubble-' + (cur.type || 'default') + '" data-duration="' + (cur.end ? Math.round((cur.end-cur.start)/1000/60/60/24/39) : '') + '"></span>',
        '<div class="label-container">',
        '<span class="label">' + cur.label + '</span>',
        '<span class="date">' + bubble.getDateLabel() + '</span>',
        '</div> ',
      ];

      html.push('<li' + lineClass + ' style="margin-left: ' + bubble.getStartOffset() + 'px; width: ' + bubble.getWidth() + 'px">' + line.join('') + '</li>');
    }

    this.container.innerHTML += '<ul class="data">' + html.join('') + '</ul>';
  };

  /**
   * Draw section labels
   */
  Timesheet.prototype.drawSections = function() {
    var html = [];

    for (var c = this.year.min; c <= this.year.max; c++) {
      html.push('<section>' + c + '</section>');
    }

    this.container.className = 'timesheet color-scheme-default';
    this.container.innerHTML = '<div class="scale" style="width:'+(60*(this.year.max-this.year.min+1))+'px">' + html.join('') + '</div>';
  };

  /**
   * Parse data string
   */
  Timesheet.prototype.parseDate = function(date) {
    if (date === 'now') {
      date = new Date();
      date.hasMonth = true;
      date.isNow = true;
    } else {
      if (date.indexOf('-') === -1) {
        date = new Date(parseInt(date, 10), 0, 1);
        date.hasMonth = false;
      } else {
        date = date.split('-');
        date = new Date(parseInt(date[0], 10), parseInt(date[1], 10)-1, parseInt(date[2], 10));
        date.hasMonth = true;
      }
    }

    return date;
  };

  /**
   * Parse passed data
   */
  Timesheet.prototype.parse = function(data) {
    for (var n = 0, m = data.length; n<m; n++) {
      var beg = this.parseDate(data[n][0]);
      var end = data[n].length === 4 ? this.parseDate(data[n][1]) : null;
      var lbl = data[n].length === 4 ? data[n][2] : data[n][1];
      var cat = data[n].length === 4 ? data[n][3] : data[n].length === 3 ? data[n][2] : 'default';

      if (beg.getFullYear() < this.year.min) {
        this.year.min = beg.getFullYear();
      }

      if (end && end.getFullYear() > this.year.max) {
        this.year.max = end.getFullYear();
      } else if (beg.getFullYear() > this.year.max) {
        this.year.max = beg.getFullYear();
      }

      this.data.push({start: beg, end: end, label: lbl, type: cat});
    }
  };
  
  /**
   * Timesheet Bubble
   */
  var Bubble = function(wMonth, min, start, end) {
    this.min = min;
    this.start = start;
    this.end = (start.getTime() !== end.getTime()) ? end : null;
    this.widthMonth = wMonth;
  };
  
  /**
   * Format month number
   */
  Bubble.prototype.formatMonth = function(num) {
    num = parseInt(num, 10);
  
    return num >= 10 ? num : '0' + num;
  };
  
  /**
   * Calculate starting offset for bubble
   */
  Bubble.prototype.getStartOffset = function() {
    return (this.widthMonth/12) * (12 * (this.start.getFullYear() - this.min) + this.start.getMonth());
  };
  
  /**
   * Get count of full years from start to end
   */
  Bubble.prototype.getFullYears = function() {
    return ((this.end && this.end.getFullYear()) || this.start.getFullYear()) - this.start.getFullYear();
  };
  
  /**
   * Get count of all months in Timesheet Bubble
   */
  Bubble.prototype.getMonths = function() {
    var fullYears = this.getFullYears();
    var months = 0;
  
    if (!this.end) {
      months += !this.start.hasMonth ? 12 : 1;
    } else {
      if (!this.end.hasMonth) {
        months += 12 - (this.start.hasMonth ? this.start.getMonth() : 0);
        months += 12 * (fullYears-1 > 0 ? fullYears-1 : 0);
      } else {
        months += this.end.getMonth() + 1;
        months += 12 - (this.start.hasMonth ? this.start.getMonth() : 0);
        months += 12 * (fullYears-1);
      }
    }
  
    return months;
  };
  
  /**
   * Get bubble's width in pixel
   */
  Bubble.prototype.getWidth = function() {
    return (this.widthMonth/12) * this.getMonths();
  };
  
  /**
   * Get the bubble's label
   */
  Bubble.prototype.getDateLabel = function() {
    return [
      this.start.getFullYear() + (this.start.hasMonth ? '-' + this.formatMonth(this.start.getMonth() + 1) : '' ) + '-' + this.formatMonth(this.start.getDate()),
      (this.end ? ' | ' + ( (this.end.isNow) ? 'actualidad' : (this.end.getFullYear() + (this.end.hasMonth ? '-' + this.formatMonth(this.end.getMonth() + 1) : '' ) + '-' + this.formatMonth(this.start.getDate()))) : '')
    ].join('');
  };

  window.Timesheet = Timesheet;
})();