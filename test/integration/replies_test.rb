require 'test_helper'



require 'sidekiq/testing'

Sidekiq::Testing.inline!

class RepliesTest < LoginTestBase

  def setup
    super
    @student_reply    = replies(:student_reply1)
    @teacher_reply    = replies(:teacher_reply2)
    @customized_tutorial_student_reply = replies(:customized_tutorial_topic1_reply2)
    @customized_tutorial_teacher_reply = replies(:customized_tutorial_topic1_reply1)

    @items                 =[[@student_session,@student],[@teacher_session,@teacher]]
    @test_replies          =[@student_reply,@teacher_reply,@customized_tutorial_student_reply,@customized_tutorial_teacher_reply]
  end

  test 'reply show' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_show(item[0],reply,item[1])
      end
    end
    # reply_show(@student_session,@student_reply,@student)
    # reply_show(@student_session,@teacher_reply,@student)
    # reply_show(@teacher_session,@teacher_reply,@teacher)
    # reply_show(@teacher_session,@student_reply,@teacher)
    # reply_show(@student_session,@customized_tutorial_student_reply,@student)
    # reply_show(@student_session,@customized_tutorial_teacher_reply,@student)
    # reply_show(@teacher_session,@customized_tutorial_teacher_reply,@teacher)
    # reply_show(@teacher_session,@customized_tutorial_student_reply,@teacher)
  end

  test 'reply edit' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_edit(item[0],reply,item[1])
      end
    end
    # reply_edit(@student_session,@student_reply,@student)
    # reply_edit(@student_session,@teacher_reply,@student)
    # reply_edit(@teacher_session,@teacher_reply,@teacher)
    # reply_edit(@teacher_session,@student_reply,@teacher)
  end

  test 'reply update' do
    @items.each do |item|
      @test_replies.each do |reply|
        reply_update(item[0],reply,item[1])
      end
    end
    # reply_update(@student_session,@student_reply,@student)
    # reply_update(@student_session,@teacher_reply,@student)
    # reply_update(@teacher_session,@teacher_reply,@teacher)
    # reply_update(@teacher_session,@student_reply,@teacher)
  end

  test 'reply create' do
    @items.each do |item|
      @test_replies.each do |reply|

        reply_create(item[0],reply,item[1])
      end
    end
    # reply_create(@student_session,@student_reply,@student)
    # reply_create(@student_session,@teacher_reply,@student)
    # reply_create(@teacher_session,@teacher_reply,@teacher)
    # reply_create(@teacher_session,@student_reply,@teacher)
  end

  test 'reply destroy 1' do
    reply_destroy(@student_session,@student_reply,@student)
    reply_destroy(@student_session,@teacher_reply,@student)
    reply_destroy(@student_session,@customized_tutorial_student_reply,@student)
    reply_destroy(@student_session,@customized_tutorial_teacher_reply,@student)
  end

  test 'reply destroy 2' do
    reply_destroy(@teacher_session,@teacher_reply,@teacher)
    reply_destroy(@teacher_session,@student_reply,@teacher)
    reply_destroy(@teacher_session,@customized_tutorial_student_reply,@teacher)
    reply_destroy(@teacher_session,@customized_tutorial_teacher_reply,@teacher)
  end

private

  def reply_destroy(user_session,reply,user)
    user_session.delete reply_path(reply)
    # if reply.author_id == user.id
    #   user_session.assert_redirected_to topic_path(reply.topic)
    #   user_session.follow_redirect!
    #   user_session.assert_template 'topics/show'
    # else
      user_session.assert_redirected_to get_home_url(user)
    # end
  end
  def reply_create(user_session,reply,user)
    content = "create a new for me  #{SecureRandom.urlsafe_base64}"
    user_session.post topic_replies_path(reply.topic),reply:{content: content}
    assert user_session.redirect?
    user_session.follow_redirect!
    # puts user_session.response.body
    user_session.assert_select 'div',content
    user_session.assert_template 'topics/show'
  end
  def reply_update(user_session,reply,user)
    content = 'xxxxjjjsssscaodan'
    user_session.put reply_path(reply),reply:{content: content}
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