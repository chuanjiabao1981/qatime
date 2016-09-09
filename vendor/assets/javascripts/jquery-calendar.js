"use strict";
(function($) {
  return $.fn.calendar = function(options) {
    var obj;
    this.initDate = new Date();
    this.element = $(this);
    this.title = $('<div class="calendar-title"></div>');//
    this.dayList = $('<div class="calendar-list"></div>');//$(this).find(".list");
    this.nav = $('<div class="calendar-nav"></div>');//$(this).find(".nav");
    obj = this;
    this.nextMonth = function() {
      this.initDate.setMonth(this.initDate.getMonth() + 1);
      return this.draw();
    };
    this.prevMonth = function() {
      this.initDate.setMonth(this.initDate.getMonth() - 1);
      return this.draw();
    };
    this.draw = function() {
      this.drawTitle();
      this.drawNav();
      this.drawList();
      this.stuffData(options['data_url'], options['callback']);
    };
    this.drawTitle = function() {
      var day, i, len, ref, results;
      $(this.title).empty();
      ref = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        day = ref[i];
        results.push($(this.title).append("<div>" + day + "</div>"));
      }
      $(this).append($(this.title));
      return results;
    };
    this.drawList = function() {
      var day, results, tmp;
      tmp = new Date(this.initDate);
      tmp.setDate(1);
      day = tmp.getDay();
      if (day === 0) {
        day = 7;
      }
      tmp.setDate(1 - day);
      $(this.dayList).empty();
      results = [];
      while (1) {
        tmp.setDate(tmp.getDate() + 1);
        var tmp_div = $("<div class='cell-"+(tmp.getMonth()+1)+"-"+tmp.getDate()+"'>" + tmp.getDate() + "</div>");
        if(tmp.toLocaleDateString() === this.initDate.toLocaleDateString()){
          tmp_div.addClass('active');
        }else{
          tmp_div.addClass('able');
        }
        tmp_div.attr('rel', tmp.toLocaleDateString());
        if(tmp.getMonth() != this.initDate.getMonth()){
          tmp_div.addClass('virtual');
        }
        $(this.dayList).append(tmp_div);
        if ((tmp.getFullYear() > this.initDate.getFullYear() || tmp.getMonth() > this.initDate.getMonth()) && tmp.getDay() === 0) {
          break;
        } else {
          results.push(void 0);
        }
      }
      $(this).append($(this.dayList));
      return results;
    };
    this.drawNav = function() {
      var year, month, day, date;
      year = $('<div class="nav-year"><span id="prev_month">&lt;</span><span id="back_today">今</span>'+this.initDate.getFullYear()+'年</div>');
      month = $('<div class="nav-month">'+(this.initDate.getMonth()+1)+'月<span id="next_month">&gt;</span></div>');
      day = $('<div class="nav-day">'+this.showDay(this.initDate.getDay())+'</div>');
      date = $('<div class="nav-date">'+this.initDate.getDate()+'</div>');
      $(this.nav).empty();
      $(this.nav).append($(year));
      $(this.nav).append($(month));
      $(this.nav).append($(date));
      $(this.nav).append($(day));
      return $(this).append($(this.nav));
    };
    this.selectDate = function(selectedDate) {
      var date;
      date = new Date(selectedDate);
      this.initDate.setYear(date.getFullYear());
      this.initDate.setMonth(date.getMonth());
      this.initDate.setDate(date.getDate());
      return this.draw();
    };
    this.showDay = function(day){
      var tmp;
      switch(day)
      {
        case 1:
          tmp = '星期一';
          break;
        case 2:
          tmp = '星期二';
          break;
        case 3:
          tmp = '星期三';
          break;
        case 4:
          tmp = '星期四';
          break;
        case 5:
          tmp = '星期五';
          break;
        case 6:
          tmp = '星期六';
          break;
        case 0:
          tmp = '星期日';
          break;
        default:
          tmp = '??';
      }
      return tmp;
    };
    this.stuffData = function(url, callback){
      if(url == null){
        return
      }
      $.get(url,{date: this.initDate.toLocaleDateString()},function(data){
        callback(data);
        //if(data['success'] != null && data['success'] == 1){
        //  //callback(data['result']);
        //  var arr = data['result'];
        //  for (var i = 0; i < arr.length; i++){
        //    var tmp_date = arr[i]['date'];
        //    tmp_date = new Date(tmp_date);
        //    var tmp_cell = $(obj).find('.cell-'+(tmp_date.getMonth()+1)+'-'+tmp_date.getDate());
        //    $(tmp_cell).addClass('able');
        //    $(tmp_cell).attr('rel', arr[i]['date']);
        //    $(tmp_cell).append('<span class="circle">&nbsp;</span>');
        //    callback(arr[i]['lessons']);
        //  }
        //}
      });
    };
    this.draw();
    $(obj).on("click", "#next_month", function() {
      return obj.nextMonth();
    });
    $(obj).on("click", "#prev_month", function() {
      return obj.prevMonth();
    });
    $(obj).on("click", ".able", function(){
      return obj.selectDate($(this).attr('rel'));
    });
    $(obj).on("click", "#back_today", function(){
      obj.initDate = new Date();
      return obj.draw();
    });
    return this;
  };
})(jQuery);