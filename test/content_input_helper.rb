module ContentInputHelper
  def set_content(content)
    find('div.note-editable').set(content)
  end

  def add_a_picture
    find('div.note-insert.btn-group').click
    attach_file("qa-img-file","#{Rails.root}/test/integration/test.jpg")
    click_on '上传图片'
  end

  def add_a_video
    click_on '添加视频'
    attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
  end

  def set_all_possible_info(content)
    set_content content
    add_a_picture
    add_a_video
  end
end