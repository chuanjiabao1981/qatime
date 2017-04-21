//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require edit_common
//= require qawechat/jweixin-1.0.0

(function($) {
  $.extend({
    toastMsg: function(msg) {
      var toastNode = $("<div class='prompt-error'><span>" + msg + "xxxx</span></div>");
      $("body").append(toastNode);
      toastNode.show().delay(3 * 1000).fadeOut(function() {
        toastNode.remove();
      });
    }
  });
})(jQuery);