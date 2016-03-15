module Qawechat
class WechatsController < ActionController::Base
  include WechatHelper
  wechat_responder

  # default text responder when no other match
  on :text do |request, content|
    request.reply.text "Echo:#{content}"
  end

  on :event, with: 'subscribe' do |request|
    nickname = wechat.user(request[:FromUserName])['nickname']
    request.reply.text "#{nickname}您好，欢迎订阅答疑时间微信服务平台。我们将竭诚为您服务！"
  end

  # When user click the menu button
  on :click, with: 'CUSTOM_COURSE' do |request, key|
    request.reply.text get_custom_courses(request[:FromUserName])
  end

  # When user sent the image
  on :image do |request|
    request.reply.image(request[:MediaId]) # Echo the sent image to user
  end

  # When user sent the voice
  on :voice do |request|
    request.reply.voice(request[:MediaId]) # Echo the sent voice to user
  end

  # When user sent the video
  on :video do |request|
    nickname = wechat.user(request[:FromUserName])['nickname']
    request.reply.video(request[:MediaId], title: 'Echo', description: "Got #{nickname} sent video") # Echo the sent video to user
  end

  # Any not match above will fail to below
  on :fallback, respond: '不好意思，我不知道该做什么，^_^'

  private
  def get_custom_courses(openid)
    wechat_user = WechatUser.find_by(openid: openid)
    unless wechat_user.nil?
      usr = User.find(wechat_user.user_id)
      user = Teacher.find(wechat_user.user_id) if usr.teacher?
      user = Student.find(wechat_user.user_id) if usr.student?
      result = "您的专属课程有：\n"
      index = 1
      user.customized_courses.each do |customized_course|
	teachers = customized_course.teachers.map {|t| t.view_name}.join(",")
        text = "#{customized_course.category}-#{customized_course.subject}-#{teachers}-#{customized_course.student.view_name}"
        result += "#{index} " + get_customized_course_href(customized_course.id, openid, text) + "\n"
        index = index + 1
      end
    end
    return result
  end

end

end
