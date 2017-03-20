$(function(){
  $(".nav-right-user").hover(function() {
    $(".nav-dropdown").show();
  }, function() {
    $(".nav-dropdown").hide();
  });

  $(".navside-list li").hover(function() {
    $(".navside-list li").addClass("active");
    $(this).find(".navside-course").show();
  }, function() {
    $(this).find(".navside-course").hide();
    $(".navside-list li").removeClass("active");
  });

  $(".item-classify-list li").hover(function() {
    $(this).find(".classify-details").show();
  }, function() {
    $(this).find(".classify-details").hide();
  });

  $(".fixed-weixin").hover(function() {
    $(this).find(".weixin-code").fadeIn(100);
  }, function() {
    $(this).find(".weixin-code").fadeOut(100);
  });

  $(window).scroll(function() {
    if($(this).scrollTop() != 0) {
      $(".fixed-top").fadeIn();
    } else {
      $(".fixed-top").fadeOut();
    }
  });

  $(".fixed-top").click(function() {
    $("body,html").animate({ scrollTop: 0 }, 200);
  });
});