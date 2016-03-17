module Qawechat
class WechatsController < ActionController::Base
  include WechatHelper
  wechat_responder

  on :text, with: 'help' do |request|
    request.reply.text '请先绑定帐号，以便接收所有通知并查看，并在菜单中查看专属课程'
  end

  on :event, with: 'subscribe' do |request|
    nickname = wechat.user(request[:FromUserName])['nickname']
    request.reply.text "#{nickname}您好，欢迎订阅答疑时间微信服务平台。我们将竭诚为您服务！"
  end

  on :event, with: 'unsubscribe' do |request|
    request.reply.success
    wechat_user = WechatUser.find_by(openid: request[:FromUserName])
    wechat_user.destroy unless wechat_user.nil?
  end

  # When user click the menu button
  on :click, with: 'CUSTOM_COURSE' do |request, key|
    get_custom_courses(request[:FromUserName]).each do |c|
      request.reply.text c
    end
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
      result = []
      result[0] = "您的专属课程有：\n"
      index = 0
      user.customized_courses.each do |customized_course|
        teachers = customized_course.teachers.map {|t| t.view_name}.join(",")
        text = "#{customized_course.category}-#{customized_course.subject}-#{teachers}-#{customized_course.student.view_name}"
        result[index % 8] += "#{index + 1} " + get_customized_course_href(customized_course.id, openid, text) + "\n"
        index = index + 1
      end
    end
    return result
  end

end

end
