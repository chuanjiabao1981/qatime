$(function(){
  var remove_fields = document.getElementsByClassName('remove_fields');
  for(var i = 0; i < remove_fields.length; i++)
  {
    $(remove_fields[i]).click(function(e)
    {
      console.log("remove_fields is called")
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      e.preventDefault()
    });
  }

  var add_fields = document.getElementsByClassName('add_fields');
  for(var i = 0; i < add_fields.length; i++)
  {
    $(add_fields[i]).click(function(e)
    {
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      e.preventDefault()
    });
  }

  $(".append_fields").click(function(e) {
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    var node = $($(this).data('fields').replace(regexp, time));
    $($(this).attr('append-to')).append(node);
    node.find(".edit-modal").modal('show');
    e.preventDefault();
  });

  // 添加记录
  $(".asyn_append_fields").on("click", ".append_fields", function(e) {
    var node = $(e.target);
    $(node.attr('append-to')).append(node.data('fields'));
    e.preventDefault();
  });

  // 删除记录
  $(".asyn_append_fields").on("click", ".remove_fields", function(e) {
    var node = $(e.target);
    node.parent().remove();
    e.preventDefault();
  });

});
