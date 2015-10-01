require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class CustomizedCourseTopicsTest < LoginTestBase

  def setup
    super
    @topic            = topics(:customized_course_topic1)
    @teacher_topic    = topics(:customized_course_topic2)
  end
  test 'topics index' do
    index_page(@student_session)
    index_page(@teacher_session)
  end

  test 'topic show' do
    show_page(@student_session)
    show_page(@teacher_session)
  end

  test 'topic new' do
    new_page(@student_session)
    new_page(@teacher_session)
  end

  test 'topic create' do
    create_page(@student_session)
    create_page(@teacher_session)
  end

  test 'topic edit' do
    edit_page(@student_session,@topic,@student)
    edit_page(@teacher_session,@topic,@teacher)
    edit_page(@student_session,@teacher_topic,@student)
    edit_page(@teacher_session,@teacher_topic,@teacher)
  end

  test 'topic update' do
    update_page(@student_session,@topic,@student)
    update_page(@teacher_session,@topic,@teacher)
    update_page(@student_session,@teacher_topic,@student)
    update_page(@teacher_session,@teacher_topic,@teacher)
  end

  test 'topic destroy 1' do
    # 可以删除
    destroy_page(@student_session,@topic,@student)
    destroy_page(@teacher_session,@teacher_topic,@teacher)
  end

  test 'topic destroy 2' do
    # 不可以删除
    destroy_page(@teacher_session,@topic,@teacher)
    destroy_page(@student_session,@teacher_topic,@student)
  end
  private

  def destroy_page(user_session,topic,user)
    user_session.delete topic_path(topic)
    if topic.author_id == user.id
      user_session.assert_redirected_to customized_course_path(topic.topicable)
    else
      user_session.assert_redirected_to get_home_url(user)

    end
  end
  def update_page(user_session,topic,user)
    title = "xdfstitleeeeeee update title update"
    user_session.put topic_path(topic),topic:{title: title,content: "xxxxxxxxxxxxxx"}
    if topic.author_id == user.id
      user_session.assert_redirected_to topic_path(topic)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    else
      user_session.assert_redirected_to get_home_url(user)
    end
  end
  def edit_page(user_session,topic,user)
    user_session.get edit_topic_path(topic)
    if topic.author_id == user.id
      user_session.assert_template 'topics/edit'
      user_session.assert_select 'form'
      user_session.assert_response :success
    else
      assert user_session.redirect?
      user_session.assert_redirected_to get_home_url(user)
    end
  end

  def create_page(user_session)
    assert_difference 'Topic.count',1 do
      title = "okokokkokokok测试一下哈哈哈哈哈哈哈+++sdafdaf"
      user_session.post customized_course_topics_path(@topic.topicable),topic:{title: title,content: "222222222222333334444444555555"}
      new_topic =  Topic.where(title: title).order(:created_at).last
      assert new_topic.customized_course_id == new_topic.topicable_id
      user_session.assert_redirected_to topic_path(new_topic)
    end


  end
  def new_page(user_session)
    user_session.get new_customized_course_topic_path(@topic.topicable)
    user_session.assert_select 'a[href=?]',topics_customized_course_path(@topic.topicable)
    user_session.assert_select 'form[action=?]',customized_course_topics_path(@topic.topicable)
    user_session.assert_template 'topics/new','customized_courses/_topic_new_layout'
    user_session.assert_response :success

  end
  def show_page(user_session)
    user_session.get topic_path(@topic)
    user_session.assert_select 'h4',@topic.title
    user_session.assert_select 'div',@topic.content
    user_session.assert_select 'form'
    user_session.assert_select 'a[href=?]', topics_customized_course_path(@topic.topicable),count: 1
    if user_session.cookies["remember_user_type"] == "student"
      user_session.assert_select 'a[href=?]',edit_topic_path(@topic)
      user_session.assert_select 'a[href=?]',topic_path(@topic)
    end
    user_session.assert_response :success
    user_session.assert_template 'customized_courses/_topic_show_layout','topics/show'

  end
  def index_page(user_session)
    user_session.get topics_customized_course_path(@topic.topicable)
    user_session.assert_select "a[href=?]", new_customized_course_topic_path(@topic.topicable), count: 1
    user_session.assert_select "a[href=?]", topic_path(@topic), count: 1
    user_session.assert_select "a[href=?]", topic_path(@teacher_topic), count: 1
    user_session.assert_template 'customized_courses/topics'
    user_session.assert_response :success
  end
end