// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  if($('.btn-reset').length > 0){
    $('.btn-reset').click(function(){
      init_filter();
      submit_form('#search-form');
    })
  }

  if($(".btn-screen").length > 0){
    $(".btn-screen").click(function(){
      assign_filter();
      submit_form('#search-form');
    })
  }

  if($('.remedial-date').length > 0){
    $('.remedial-date').each(function(_, el){
      $(el).click(function(){
        show_calendar(this)
      })
    })
  }

  if($('.more-conditions').length > 0){
    $(".more-conditions").click(function(){
      $(".screening-hidden").slideDown(500);
      $(".up-conditions").show();
      $(".more-conditions").hide();
   })
  }

  if($(".up-conditions").length > 0){
    $(".up-conditions").click(function  () {
      $(".screening-hidden").slideUp(500);
      $(".up-conditions").hide();
      $(".more-conditions").show();
    })
  }

  if($("li[class*= '-1'][class*='list-']").length > 0){
    $("li[class*= '-1'][class*='list-']").each(function(_, el){
      $(el).click(function(){
        var list_class = $(this).removeClass('active-color').attr('class');
        var index = $("."+list_class).index($(this));
        $(this).addClass('active-color').siblings().removeClass('active-color');
      })
    })
  }

  if($(".list-screening li").length > 0){
    $(".list-screening li").each(function(index, _){
      $(".list-screening li").eq(index).hover(function(){
        $(".dd-num-msg").eq(index).show();
      }, function(){
        $(".dd-num-msg").eq(index).hide();
      })
    })

    $(".list-screening li").each(function(index, el) {
      var _this=$(this).find(".dd-num-msg");
      $(this).mouseenter(function () {
        $(_this).show();
      })
      $(this).mouseleave(function () {
        $(_this).hide();
      })
    })
  }

})

function init_filter(){
  var filter_arr = [
      ['#sort_by','all'], ['#subject','all'], ['#grade','all'], ['#status','all'],
      ['#price_floor',''],['#price_ceil',''], ['#preset_lesson_count_floor',''],
      ['#preset_lesson_count_ceil',''],['#dateinfo',''], ['#dateinfo_2','']
    ]
  $(filter_arr).each(function(_,el){
    $(el[0]).val(el[1]);
  })
}

function assign_filter(){
  $('.active-color').each(function(_,el){
    var tag = $(el).attr('rel');
    var value = $(el).attr('data');
    if(tag.indexOf('_sort') > 0){
      $("#sort_by").val(tag.replace('_sort','') +"."+value);
    }else{
      $("#"+tag).val(value);
    }
  })
}

function submit_form(form){
  $(form).submit();
}

function show_calendar(el){
  $.jeDate(el, {
    insTrigger:false,
    //isinitVal:true,
    format:"YYYY-MM-DD", // 分隔符可以任意定义，该例子表示只显示年月
    isClear:false,
    festival: true, //显示节日
    minDate: '2000-06-01', //设定最小日期为当前日期
    //最大日期
  });
}
