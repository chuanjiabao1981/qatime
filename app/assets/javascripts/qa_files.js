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
    var regexp = new RegExp(node.data('prefix') + "_\\d+", 'g');
    $(node.attr('append-to')).append(node.data('fields').replace(regexp, node.data('id')));
    node.data('id', parseInt(node.data('id')) + 1); 
    e.preventDefault();
  });

  // 删除记录
  $(".asyn_append_fields").on("click", ".remove_fields", function(e) {
    var node = $(e.target);
    node.parent().remove();
    e.preventDefault();
  });

  // 新增文件文件
  $(".asyn_append_files").on("click", ".append_files", function(e) {
    var count = $(e.target).closest('.form-file').find('.file-img:visible').size();
    if(count >= 6) return false;
    var node = $(e.target).closest('.append_files');
    var regexp = new RegExp(node.data('prefix') + "_\\d+", 'g');
    node.closest('.file-img').before(node.data('fields').replace(regexp, node.data('id')))
    node.data('id', parseInt(node.data('id')) + 1);
    node.closest('.file-img').prev().find('input').click();
    node.closest('.file-img').prev().hide().find('.destroy').val('1');
    e.preventDefault();
  });

  function getObjectURL(file) {
    var url = null;
    if(window.createObjectURL != undefined) {
      url = window.createObjectURL(file);
    } else if(window.URL != undefined) {
      url = window.URL.createObjectURL(file);
    } else if(window.webkitURL != undefined) {
      url = window.webkitURL.createObjectURL(file);
    }
    return url;
  }

  // 显示图片节点
  function showImage(image, fileSrc) {
    if(fileSrc) image.show().find('img').attr('src', fileSrc);
  }

  // 提交图片
  function fileSubmit(image, file) {
    var attachmentForm = '<form action="/live_studio/attachments" enctype="multipart/form-data" method="post"></form>';
    var data = new FormData();
    data.append("attachment[file]", file, file.name);
    $(attachmentForm).ajaxSubmit({
      dataType: 'json',
      formData: data,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      beforeSubmit: function(){
        // 显示缩略图
        showImage(image, getObjectURL(file));
        // 初始化进
        image.find('.upload-progress').removeClass('error');
        image.find('span.progress').text('0%').show().siblings().hide();
      },
      uploadProgress: function(event, position, total, percentComplete) {
        var percentVal = percentComplete + '%';
        image.find('span.progress').text(percentVal);
      },
      success: function(data) {
        image.find('img').attr('src', data.file_url);
        // 显示删除按钮
        image.find('a.delete').show();
        // 设置附件ID
        image.find('.attachment_id').val(data.id);
        image.find('.attachment_file').remove();
      },
      error: function() {
        // 显示失败信息
        image.find('span.fail').show().siblings().hide();
        // 显示重选按钮
        image.find('a.reset').show().closest('.upload-progress').addClass('error');
      }
    });

  }

  // 上传图片
  $('.asyn_append_files').on('change', '.attachment_file', function(e) {
    var file = e.target.files[0];
    if(!file) return false;

    if(!file.name.match(/.[(jpg)(png)]$/i)) {
      alert("图片格式不正确");
      $(this).val('');
      return false;
    }

    var node = $(e.target).closest('.file-img');
    // 显示节点并取消删除
    node.show().find('.destroy').val('0');
    fileSubmit(node, file);
  });

  // 删除图片
  $('.asyn_append_files').on('click', '.file-img .delete', function(e) {
    $(e.target).prev('input[type=hidden]').val('1');
    $(e.target).closest('.file-img').hide();
    e.preventDefault();
  });

  // 重选
  $('.asyn_append_files').on('click', '.file-img .reset', function(e) {
    var node = $(e.target).closest('.file-img');
    $(e.target).closest('.form-file').find('.attachment_file').data('currentID', node.attr('id')).click();
  });
});
