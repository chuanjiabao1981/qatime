$(document).ready(function(){
  $('button[data-edit-area]').on('click',function(event){
    var $node = $(event.target)
    var $edit_area = $($node.data('edit-area'))
    $edit_area.show();
  });

  $('button[data-edit-area2]').on('click',function(event){
    var $node = $(event.target)
    var edit_area = $($node.data('edit-area2'))
    window.location.href= edit_area
  });

  $("button[data-form-reset").on('click',function(event){
    var $node = $(event.target)
    var $form = $node.data('form-el')
    var jump_href = $node.data('jump-href')

    $($form)[0].reset()
    if(jump_href){
      window.location.href= jump_href
    }
  });

  $("button[data-jump-btn").on('click',function(event){
    var $node = $(event.target)
    var jump_href = $node.data('jump-href')

    window.location.href= jump_href
  });


  $("button[data-form-submit]").on('click',function(event){
    var $node = $(event.target)
    var $form = $node.data('form-el')
    $($form).submit()
  });

  $('input[data-send-captcha-btn]').on('click',function(event){
    var $node = $(event.target)
    var send = this
    var send_to_input = $($node.data('send-to-input'))[0]
    var next_btn = $($node.data('next-btn'))

    var send_data = ''
    var send_url = $node.data('send-url')
    var send_type = $node.data('send-type')

    if(send_to_input){
      var pattern = /\[(.*)\]/;
      var input_name = send_to_input.name;
      var result = input_name.match(pattern);

      send_data = {}
      send_data["send_to"] = send_to_input.value
      send_data["send_type"] = send_type

    }
    console.log(send_data)
    $.ajax({
      url: send_url,
      data: send_data,
      dataType: 'json',
      type: "POST",

      error: function(xhr, statusText, errorThrown, $form){
        alert(xhr.responseText)
      },

      success: function(responseText, statusText, xhr, $form){
        if(next_btn){
          times=60,
          timer=null;

          next_btn.removeAttr("disabled")

          timer=setInterval(function(){
            times--;
            if(times<=0){
              send.value='获取验证码';
              clearInterval(timer);
              send.disabled=false;
            }else{
              send.value=times+'秒后重试'
              send.disabled=true;
            }
          },1000)
        }
      }
    });
  });
})
