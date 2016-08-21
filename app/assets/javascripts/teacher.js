
// <script type="text/javascript">
//   $(document).ready(function() {
//     $(".edit_teacher").ajaxForm({
//       dataType:'json',
//       error: function(xhr, statusText, errorThrown, $form){
//         var responseText = JSON.parse(xhr['responseText'])
//         techer_id = responseText['id']
//         var r_errors  = responseText['errors']
//         var edit_div = "#teacher_edit_" + techer_id

//         for(var k in r_errors){
//           var edit_input = edit_div + ' #teacher_' + k
//           if(!$(edit_input).parent().hasClass("has-error")){
//             error_span_id = "span_teacher_" + techer_id + '_' + k
//             $(edit_input).parent().addClass("has-error").append('<span class="help-block has-error">' + r_errors[k] + '</span>');
//           }
//         }
//       },
//       success: function(responseText, statusText, xhr, $form){
//         techer_id = responseText['id']
//         var update_attr  = responseText['update_attr']
//         var edit_div = "#teacher_edit_" + techer_id
//         var edit_input = edit_div + ' #teacher_' + update_attr

//         if($(edit_input).parent().hasClass("has-error")){
//           console.log($(edit_input).parent())
//           $(edit_input).parent().removeClass("has-error")
//           var error_span = $('#teacher_edit_3 #teacher_password').next()
//           error_span.remove()
//         }
//         $(edit_input).parent().append('<span class="help-block has-error"><%= t("flash.notice.update_success") %></span>');
//       }
//     });
//   });
// </script>
