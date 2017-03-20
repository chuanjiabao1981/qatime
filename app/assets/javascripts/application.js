// This is a manifest file that'll be compiled into application.js, which will include all the files
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
//= require jquery_ujs
//= require jquery.Jcrop
//= require bootstrap
//= require summernote
//= require jquery.form
//= require video-js
// require jwplayer/jwplayer
// require jwplayer/jwpsrv_frq
// require jwplayer/jwpsrv
//= require jquery.menu-aim
//= require chosen-jquery
//= require canvas-to-blob.min
//= require fancybox
//= require_tree .
//= require editable/bootstrap-editable
//= require editable/rails
//= require bootstrap-select.min
//= require defaults-zh_CN
//= require moment.min
//= require calendar-zh-cn.js
//= require calendar-es5
//= require jedate
//= require jquery.jedate

// 判断空 $.isBlank($(this).val())
$.isBlank = function(obj) {
  return(!obj || $.trim(obj) === "");
};

$(document).on('click', '.je-date', function (event) {
  $.jeDate(event.target,{
    skinCell:"jedateblue",
    festival:false,
    insTrigger: true,
    format:"YYYY-MM-DD",
    isClear:false,
    minDate: '2000-12-12'
  });
});

$(function() {
  $(".nav-condition").hover(function() {
    $(this).find("ul").show();
  }, function() {
    $(this).find("ul").hide();
  });
});
