require 'test_helper'

class LiveStudio::TeacherLessonTest < ActionDispatch::IntegrationTest

  def setup
    @course = live_studio_courses(:tasting_course)
  end

  test 'new lesson status ready or init' do
    ready_lesson = @course.lessons.create(
        name: 'test ready',
        description: 'test desc',
        start_time: '12:00',
        end_time: '12:30',
        class_date: Date.today
    )
    assert ready_lesson.ready?, 'class_date为今天应该为ready状态'
    init_lesson = @course.lessons.create(
        name: 'test ready',
        description: 'test desc',
        start_time: '12:00',
        end_time: '12:30',
        class_date: Date.tomorrow
    )
    assert init_lesson.init? ,'class_date为明天应该为init状态'
  end

  test 'service lesson start course teaching?' do
    preview_course = live_studio_courses(:course_preview)
    ready_lesson = live_studio_lessons(:ready_lesson_today2)
    LiveService::LessonDirector.new(ready_lesson).lesson_start
    preview_course.reload
    ready_lesson.reload
    assert preview_course.teaching? ,'辅导班应改为上课中'
    assert ready_lesson.live_start_at.present?, '课程直播开始时间为空'
    assert preview_course.lessons.waiting_finish.blank?, 'closed paused 的数据不为空'
    assert ready_lesson.live_sessions.present?, '直播中的课程应该有心跳记录'
  end

  test 'service lesson start false' do
    false_lesson = live_studio_lessons(:ready_lesson_for_false)
    flag = LiveService::LessonDirector.new(false_lesson).lesson_start
    assert !flag, '已有直播中的辅导班开始直播课程会返回false'
  end

  test 'service ready_today_lessons status change' do
    LiveService::LessonDirector.ready_today_lessons
    assert LiveStudio::Lesson.today.init.blank?, '错误存在今日的初始化课程'
  end

  test 'service clean_lessons status change' do
    LiveService::LessonDirector.clean_lessons
    assert LiveStudio::Lesson.waiting_finish.where('class_date <= ?',Date.yesterday).blank?,
           '错误存在昨天(包括)以前的paused, closed状态下的课程没有被finish'
    assert LiveStudio::Lesson.teaching.where('class_date < ?', Date.yesterday).blank?,
        '错误存在上课时间在前天(包括)以前并且状态为teaching的课程没有被finish'
  end
  #
  test 'service billing_lessons status change' do
    LiveService::LessonDirector.billing_lessons
    assert LiveStudio::Lesson.should_complete.blank?, '错误存在未complete符合条件课程'
  end

  test 'service pause_lessons status change' do
    should_paused = live_studio_lessons(:teaching_lesson)
    LiveService::LessonDirector.pause_lessons
    should_paused.reload
    assert should_paused.paused?, '课程未暂停'
  end
end
