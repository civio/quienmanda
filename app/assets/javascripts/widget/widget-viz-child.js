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
//= require ./pym.min.js
//= require bootstrap-sprockets
//= require ../spin.min.js
//= require_directory ../viz
//= require ../custom.js


jQuery.noConflict();

var embeded;

jQuery(document).ready(function($) {

  embeded = new pym.Child();
  $('#control-fullscreen, #control-fullscreen-exit').click(function() {
    embeded.sendMessage('fullscreen', $('#viz-container').hasClass('fullscreen') ? '1' : '0');
  });
});