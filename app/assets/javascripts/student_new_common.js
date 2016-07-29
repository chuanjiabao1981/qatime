$(document).ready(function(){
  $("button[data-form-reset]").on('click',function(event){
    var $node = $(event.target)
    var $form = $node.data('form-el')
    var jump_href = $node.data('jump-href')

    $($form)[0].reset()
    if(jump_href){
      window.location.href= $node.data('jump-href')
    }
  });
  $("button[data-form-submit]").on('click',function(event){
    var $node = $(event.target)
    var $form = $node.data('form-el')
    $($form).submit()
  });

})
