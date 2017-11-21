require 'test_helper'

module Social
  class CourseHomeworkFeddTest < ActiveSupport::TestCase
    # 老师布置作业产生动态
    test "teacher create a homework feed" do
      group = live_studio_groups(:schedule_published_group1)
      @teacher = group.teacher
      @student_one = users(:student1)
      @student_two = users(:student2)
      @student_three = users(:student_one_with_course)
      task_items = [{ body: '第1题' }, { body: '第2题' }, { body: '第3题' }, { body: '第4题' }, { body: '第5题' }, { body: '第6题' }]
      assert_difference "Social::CourseHomeworkFeed.count", 1, "布置作业没有生成动态" do
        @homework = group.homeworks.create(user: @teacher, title: '留个作业看看动态', task_items_attributes: task_items)
      end
      @feed = Social::Feed.order(:created_at).last
      assert_equal @homework, @feed.feedable, "动态feedable不正确"
      assert_equal @teacher, @feed.producer, "动态producer不正确"
      assert_nil @feed.target, "动态target不正确"
      assert_equal group, @feed.linkable, "动态linkable不正确"
      assert_equal 2, @feed.feed_publishs.count, "动态发布不正确"
    end

    # 学生做作业产生动态
    test "student submit homework create a feed" do
      student_homework = live_studio_tasks(:student_homework_one)

      items = student_homework.homework.task_items.map do |item|
        { parent_id: item.id, body: '我不会' }
      end
      assert_difference "Social::CourseHomeworkFeed.count", 1, "提交作业产生动态错误" do
        student_homework.update(task_items_attributes: items)
      end
      @feed = Social::Feed.order(:created_at).last
      assert_equal student_homework, @feed.feedable, "动态feedable不正确"
      assert_equal student_homework.user, @feed.producer, "动态producer不正确"
      assert_equal student_homework.homework.user, @feed.target, "动态target不正确"
      assert_equal student_homework.taskable, @feed.linkable, "动态linkable不正确"
      assert_equal 2, @feed.feed_publishs.count, "动态发布不正确"
    end

    # 老师批改产生动态
    test "teacher correct homework create a feed" do
      student_homework = live_studio_tasks(:student_homework_two)

      items = student_homework.task_items.map do |item|
        { parent_id: item.id, body: '做错了' }
      end
      correction = student_homework.build_correction(task_items_attributes: items)
      correction.user = users(:student1)

      assert_difference "Social::CourseHomeworkFeed.count", 1, "提交作业产生动态错误" do
        correction.save
      end

      @feed = Social::Feed.order(:created_at).last
      assert_equal correction, @feed.feedable, "动态feedable不正确"
      assert_equal correction.user, @feed.producer, "动态producer不正确"
      assert_equal correction.student_homework.user, @feed.target, "动态target不正确"
      assert_equal correction.taskable, @feed.linkable, "动态linkable不正确"
      assert_equal 2, @feed.feed_publishs.count, "动态发布不正确"
      assert_equal 'resolve', @feed.event, "动态发布不正确"
    end

    # 老师重新批改产生动态
    test "teacher update correction create a feed" do
      student_homework = live_studio_tasks(:student_homework_three)

      items = student_homework.task_items.map do |item|
        { parent_id: item.id, body: '做错了' }
      end
      correction = student_homework.build_correction(task_items_attributes: items)
      correction.user = users(:teacher1)
      assert correction.save, "批改出错"

      student_homework.reload.correction.delete
      items = student_homework.task_items.map do |item|
        { parent_id: item.id, body: '做对了' }
      end
      correction = student_homework.build_correction(task_items_attributes: items)
      correction.user = users(:teacher1)

      assert_difference "Social::CourseHomeworkFeed.count", 1, "提交作业产生动态错误" do
        correction.save
      end

      @feed = Social::Feed.order(:created_at).last
      assert_equal 'update_resolve', @feed.event, "动态发布不正确"
    end
  end
end
