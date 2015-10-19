module ContentInputHelper
  def set_content(content)
    find('div.note-editable').set(content)
  end

  def add_a_picture
    find('div.note-insert.btn-group').click
    attach_file("qa-img-file","#{Rails.root}/test/integration/test.jpg")
    click_on '上传图片'
    sleep 5
  end

  def add_a_video
    click_on '添加视频'
    attach_file("video_name","#{Rails.root}/test/integration/test.mp4")
    sleep 5
  end

  def set_all_possible_info(content)
    set_content content
    add_a_picture
    add_a_video
  end

  def add_video_and_picture(object,content=nil)
    if object.new_record?
      action = "新增"

    else
      action = "更新"

    end
    content = '这个不能少于2ssssssss0啊啊啊啊啊啊啊啊啊啊12345678900987654321' if content.nil?
    set_all_possible_info(content)
    assert page.has_content? content
    click_on "#{action}#{object.model_name.human}"
  end

  def assert_picture(object)
    p   = Picture.where(imageable_type: object.class.reflections["pictures"].active_record.to_s).order(created_at: :desc).first
    assert object.picture_ids.include?(p.id),'要包含图片'
  end

  def assert_video(object)
    v   = Video.where(videoable_type: object.class.reflections["video"].active_record.to_s).order(updated_at: :desc).first
    assert object.reload.video.id == v.id,'要有视频'
  end
end