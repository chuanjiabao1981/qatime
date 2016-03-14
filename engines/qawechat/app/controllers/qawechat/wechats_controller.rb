module Qawechat
class WechatsController < ActionController::Base
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
    result = ""
    unless WechatUser.find_by(openid: openid).nil?
      user = User.find(wechat_user.user_id)
      user.customized_courses.each do |customized_course|
        text = "#{customized_course.category}-#{customized_course.subject}-#{customized_course.teacher}-#{customized_course.student}"
        result += '【<a href="' + customized_course_path(customized_course) + '">' + text +'</a>】'
      end
    end
    return result
  end

end

end
