module Qawechat
class WechatsController < ActionController::Base
  wechat_responder

  # default text responder when no other match
  on :text do |request, content|
    request.reply.text "echo: #{content}"
  end

  # When receive 'hello', will trigger this responder
  on :text, with: 'hello' do |request|
    request.reply.text 'hello, who are you?'
  end

  # When receive '<n>news', will match and will got count as <n> as parameter
  on :text, with: /^(\d+) news$/ do |request, count|
    # Wechat article can only contain max 10 items, large than 10 will dropped.
    news = (1..count.to_i).each_with_object([]) { |n, memo| memo << { title: 'News title', content: "No. #{n} news content" } }
    request.reply.news(news) do |article, n, index| # article is return object
      article.item title: "#{index} #{n[:title]}", description: n[:content], pic_url: 'http://www.baidu.com/img/bdlogo.gif', url: 'http://www.baidu.com/'
    end
  end

  on :event, with: 'subscribe' do |request|
    nickname = wechat.user(request[:FromUserName])['nickname']
    request.reply.text "#{nickname}您好，欢迎订阅答疑时间微信服务平台。我们将竭诚为您服务！"
  end

  # When unsubscribe user scan qrcode qrscene_xxxxxx to subscribe in public account
  # notice user will subscribe public account at same time, so wechat won't trigger subscribe event any more
  on :scan, with: 'qrscene_xxxxxx' do |request, ticket|
    request.reply.text "Unsubscribe user #{request[:FromUserName]} Ticket #{ticket}"
  end

  # When subscribe user scan scene_id in public account
  on :scan, with: 'scene_id' do |request, ticket|
    request.reply.text "Subscribe user #{request[:FromUserName]} Ticket #{ticket}"
  end

  # When no any on :scan responder can match subscribe user scaned scene_id
  on :event, with: 'scan' do |request|
    if request[:EventKey].present?
      request.reply.text "event scan got EventKey #{request[:EventKey]} Ticket #{request[:Ticket]}"
    end
  end

  # When user click the menu button
  on :click, with: 'CUSTOM_COURSE' do |request, key|
    request.reply.text "User: #{request[:FromUserName]} click #{key}"
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

  on :event, with: 'unsubscribe' do |request|
    request.reply.success # user can not receive this message
  end

  # Any not match above will fail to below
  on :fallback, respond: '不好意思，我不知道该做什么，^_^'
end

end
