require 'test_helper'

module Social
  class CourseQuestionFeedTest < ActiveSupport::TestCase
    # 学生提问产生动态
    test "student create a question feed" do
      @group = live_studio_groups(:schedule_published_group1)
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      assert_difference "Social::CourseQuestionFeed.count", 1, "产生动态数量不正确" do
        @question = @group.questions.create(title: '提个问题试试', body: '地球为什么是圆的', user: @student_three)
      end

      @feed = Social::CourseQuestionFeed.last
      assert_equal @question, @feed.feedable, "动态feedable不正确"
    end

    # 老师回问题答产生动态
    test "teacher create a answer with feed" do
      @group = live_studio_groups(:schedule_published_group1)
      @question = live_studio_tasks(:question_one)
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      @answer = @question.build_answer(body: '因为地球有引力', user: @teacher)
      assert_difference "Social::CourseQuestionFeed.count", 1, "产生动态数量不正确" do
        @answer.save
      end

      @feed = Social::CourseQuestionFeed.last
      assert_equal @answer, @feed.feedable, "动态feedable不正确"
    end

    # 老师重新回答产生动态
    test "teacher update a answer with feed" do
      @group = live_studio_groups(:schedule_published_group1)
      @question = live_studio_tasks(:question_one)
      @teacher = @group.teacher
      @student_three = users(:student_one_with_course)

      @answer = @question.build_answer(body: '因为地球有引力啦啦', user: @teacher)
      assert_difference "Social::CourseQuestionFeed.count", 1, "产生动态数量不正确" do
        @answer.save
      end
      @answer = @question.build_answer(body: '没有为什么计时这样啦', user: @teacher)
      assert_difference "Social::CourseQuestionFeed.count", 1, "产生动态数量不正确" do
        @answer.save
      end

      @feed = Social::CourseQuestionFeed.last
      assert_equal @answer, @feed.feedable, "动态feedable不正确"
      assert_equal 'update_resolve', @feed.event, "重新回答不正确"
    end
  end
end
