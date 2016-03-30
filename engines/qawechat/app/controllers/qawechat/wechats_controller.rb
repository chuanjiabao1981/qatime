module Qawechat
class WechatsController < ActionController::Base
  include WechatHelper
  wechat_responder

  on :text, with: 'help' do |request|
    request.reply.text '请先绑定帐号(测试账号：s@qatime.cn，密码s；t@qatime.cn，密码t)，以便接收所有通知并查看，并在菜单中查看专属课程;语音测试地址：http://rails.wrcomputer.cn/qawechat/wechat_voice'
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
    messages = get_custom_courses(request[:FromUserName])
    if messages.size == 0
      request.reply.text "很抱歉，您还没有开通专属课程！"
    elsif messages.size == 1
      request.reply.text "您的专属课程有：\n#{messages[0]}"
    else
      index = 1
      messages.each do |m|
	message = "您的专属课程有(#{ index }/#{messages.size})：\n#{m}"
        WechatWorker.perform_async(WechatWorker::REPLY,openid: request[:FromUserName], message: message)
	index = index + 1
      end
      request.reply.success
    end
  end

  # Any not match above will fail to below
  on :fallback, respond: '不好意思，我不知道该做什么，^_^'

  private
  def get_custom_courses(openid)
    wechat_user = WechatUser.find_by(openid: openid)
    messages = []
    unless wechat_user.nil?
      usr = User.find(wechat_user.user_id)
      user = Teacher.find(wechat_user.user_id) if usr.teacher?
      user = Student.find(wechat_user.user_id) if usr.student?
      index = 1
      message = ""
      user.customized_courses.each do |customized_course|
        teachers = customized_course.teachers.map {|t| t.view_name}.join(",")
        text = "#{customized_course.category}-#{customized_course.subject}-#{teachers}-#{customized_course.student.view_name}"
        message += "· " + get_customized_course_href(customized_course.id, openid, text) + "\n"
        if (index % 5 == 0 and index != 1) or (index == user.customized_courses.size)
	  messages.push(message)
          message = ""
        end
        index = index + 1
      end
    end
    return messages
  end

end

end
