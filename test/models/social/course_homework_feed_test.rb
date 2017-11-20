require 'test_helper'

module Social
  class CourseHomeworkFeddTest < ActiveSupport::TestCase
    # 老师布置作业产生动态
    test "teacher create a homework feed" do
      group = live_studio_groups(:schedule_published_group1)
      @teacher = group.teacher
      binding.pry
      @student_one = users(:student1)
      @student_two = users(:student2)
      @student_three = users(:student_one_with_course)
      task_items = [{ body: '第1题' }, { body: '第2题' }, { body: '第3题' }, { body: '第4题' }, { body: '第5题' }, { body: '第6题' }]
      assert_difference "Social::Feed.count", 1, "布置作业没有生成动态" do
        group.homeworks.create(user: @teacher, title: '留个作业看看动态', task_items_attributes: task_items)
      end
      @feed = Social::Feed.last
      @homework = LiveStudio::Homework.lat
      assert_equal @homework, feed.feedable, "动态feedable不正确"
    end

    # 学生做作业产生动态
    test "student submit homework create a feed" do
    end

    # 老师批改产生动态
    test "teacher correct homework create a feed" do
    end

    # 老师重新批改产生动态
    test "teacher update correction create a feed" do
    end
  end
end
