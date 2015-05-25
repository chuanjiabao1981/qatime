require 'test_helper'

class TopicsTest < LoginTestBase

  def setup
    super
    @topic  = topics(:topic1)
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
    edit_page(@student_session)
    edit_page(@teacher_session)
  end

  test 'topic update' do

  end
private

  def update_page(user_session)

  end
  def edit_page(user_session)
    user_session.get edit_topic_path(@topic)
    if user_session.cookies["remember_user_type"] == "student"
      user_session.assert_template 'topics/edit'
      user_session.assert_select 'form'
      user_session.assert_response :success
    else
      assert user_session.redirect?
    end
  end

  def create_page(user_session)
    assert_difference 'Topic.count',1 do
      title = "测试一下哈哈哈哈哈哈哈"
      user_session.post lesson_topics_path(@topic.lesson),topic:{title: title,body: "222222222222333334444444555555"}
      new_topic =  Topic.where(title: title).order(:created_at).last

      user_session.assert_redirected_to topic_path(new_topic)
    end


  end
  def new_page(user_session)
    user_session.get new_lesson_topic_path(@topic.lesson)
    user_session.assert_select 'form'
    user_session.assert_template 'topics/new'
    user_session.assert_response :success

  end
  def show_page(user_session)
    user_session.get topic_path(@topic)
    user_session.assert_select 'h4',@topic.title
    user_session.assert_select 'div',@topic.body
    user_session.assert_select 'form'
    if user_session.cookies["remember_user_type"] == "student"
      user_session.assert_select 'a[href=?]',edit_topic_path(@topic)
      user_session.assert_select 'a[href=?]',topic_path(@topic)
    end
  end
  def index_page(user_session)
    user_session.get lesson_path(@topic.lesson)
    user_session.assert_select "a[href=?]", new_lesson_topic_path(@topic.lesson), count: 1
    #头部一个，左侧一个
    user_session.assert_select "a[href=?]", lesson_path(@topic.lesson), count: 2
    user_session.assert_select "a[href=?]", topic_path(@topic), count: 1
    user_session.assert_template 'lessons/show'
    user_session.assert_response :success
  end
end