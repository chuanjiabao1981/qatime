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
//= require v1/js.cookie
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
//= require editable/bootstrap-editable
//= require editable/rails
//= require bootstrap-select.min
//= require defaults-zh_CN
//= require moment.min
//= require calendar-zh-cn.js
//= require calendar-es5
//= require jedate
//= require jquery.jedate
//= require v1/home
//= require util

// 判断空 $.isBlank($(this).val())
$.isBlank = function(obj) {
  return(!obj || $.trim(obj) === "");
};

function jeDateShow(elem){
  var d = new Date();
  var vYear = d.getFullYear();
  var vMon = d.getMonth() + 1;
  var vDay = d.getDate();
  var min_date = vYear + '-' + (vMon<10 ? "0" + vMon : vMon) + '-' + (vDay<10 ? "0"+ vDay : vDay);
  $.jeDate(elem,{
    skinCell:"jedateblue",
    festival:false,
    insTrigger:false,
    isToday: false,
    //isinitVal:true,
    format:"YYYY-MM-DD",
    isClear:false,
    minDate: min_date
  });
}

$(function() {
  $(".nav-condition").hover(function() {
    $(this).find("ul").show();
  }, function() {
    $(this).find("ul").hide();
  });

  $(document).on('click', '.je-date', function (event) {
    jeDateShow(event.currentTarget);
  });
});