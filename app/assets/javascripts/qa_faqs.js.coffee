$(document).ready ->
  $('[data-provider="summernote-qa"]').each ->
    $(this).summernote
      lang: 'zh-CN'
      height: 400
