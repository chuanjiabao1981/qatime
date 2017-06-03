require 'test_helper'



require 'sidekiq/testing'

Sidekiq::Testing.inline!

class RepliesTest < LoginTestBase

  def setup
    super
    @student_reply    = replies(:student_reply1)
    @teacher_reply    = replies(:teacher_reply2)

    @items                 =[[@student_session,@student],[@teacher_session,@teacher]]
    @test_replies          =[@student_reply,@teacher_reply]
  end

  test 'reply show' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_show(item[0],reply,item[1])
      end
    end

  end

  test 'reply edit' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_edit(item[0],reply,item[1])
      end
    end
  end

  test 'reply update' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_update(item[0],reply,item[1])
      end
    end
  end

  test 'reply create' do
    @items.each do |item|
      @test_replies.each do |reply|

        reply_create(item[0],reply,item[1])
      end
    end
  end

  test 'reply destroy 1' do
    reply_destroy(@student_session,@student_reply,@student)
    reply_destroy(@student_session,@teacher_reply,@student)
  end

  test 'reply destroy 2' do
    reply_destroy(@teacher_session,@teacher_reply,@teacher)
    reply_destroy(@teacher_session,@student_reply,@teacher)
  end

private

  def reply_destroy(user_session,reply,user)
    user_session.delete reply_path(reply)

    user_session.assert_redirected_to get_home_url(user)
  end
  def reply_create(user_session,reply,user)
    content = "create a new for me  #{SecureRandom.urlsafe_base64}"
    user_session.post topic_replies_path(reply.topic), params: { reply: { content: content } }
    assert user_session.redirect?
    user_session.follow_redirect!
    # puts user_session.response.body
    user_session.assert_select 'div',content
    user_session.assert_template 'topics/show'
  end
  def reply_update(user_session, reply, user)
    content = 'xxxxjjjsssscaodan'
    user_session.put reply_path(reply), params: { reply: { content: content } }
    if user.id == reply.author_id
      assert user_session.redirect?
      user_session.follow_redirect!
      user_session.assert_select 'div',content
    else
      assert user_session.redirect?
      user_session.assert_redirected_to get_home_url(user)
    end
  end
  def reply_edit(user_session,reply,user)
    user_session.get edit_reply_path(reply)
    if user.id == reply.author_id
      user_session.assert_template 'replies/edit'
      user_session.assert_select 'form'
      user_session.assert_response :success
    else
      assert user_session.redirect?
      user_session.assert_redirected_to get_home_url(user)
    end
  end
  def reply_show(user_session,reply,user)
    user_session.get topic_path(reply.topic)
    user_session.assert_template 'topics/show'
    if user.id == reply.author_id
      user_session.assert_select "a[href=?]", edit_reply_path(reply),1
      # user_session.assert_select "a[href=?]", reply_path(reply),1
    else
      user_session.assert_select "a[href=?]", edit_reply_path(reply),0
      # user_session.assert_select "a[href=?]", reply_path(reply),0
    end
  end
end