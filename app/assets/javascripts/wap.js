//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require edit_common
//= require qawechat/jweixin-1.0.0
//= require browsers

(function($) {
  $.extend({
    toastMsg: function(msg) {
      var toastNode = $("<div class='prompt-error'><span>" + msg + "</span></div>");
      $("body").append(toastNode);
      toastNode.show().delay(3 * 1000).fadeOut(function() {
        toastNode.remove();
      });
    }
  });
})(jQuery);