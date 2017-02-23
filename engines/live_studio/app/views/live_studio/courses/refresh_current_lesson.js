var status_span = $("#show_current_lesson_status")
<% if @current_lesson %>
  <% if @current_lesson.paused? %>
    if(!status_span.hasClass('current_lesson_paused')){
      status_span.addClass('current_lesson_paused')
      status_span.html("<%= t 'view.play.current_lesson_paused' %>")
    }
  <% else %>
    if(status_span.hasClass('current_lesson_paused')){
      status_span.removeClass('current_lesson_paused')
    }
    status_span.html("")
  <% end %>
<% else %>
  if(status_span.hasClass('current_lesson_paused')){
    status_span.removeClass('current_lesson_paused')
  }
  status_span.html("<%= t 'view.play.no_current_lesson' %>")
<% end %>
