require 'test_helper'


class CoursesTest < LoginTestBase
  def setup
    super
    @course = courses(:teacher1_course)
  end

  test 'course new' do
    binding.pry
    @teacher_session.get edit_teachers_curriculum_course_path(@course.curriculum, @course)
    @teacher_session.assert_template 'courses/edit'
    @teacher_session.assert_response :success
    @teacher_session.assert_select 'form'
  end
  test 'course create' do
    curriculum    = @teacher.curriculums.first
    chapter       =  curriculum.teaching_program.content["chapters"][0]
    assert_difference 'Course.count', 1 do
      @teacher_session.post teachers_curriculum_courses_path(@teacher.curriculums.first),
                            params: {
                              course: {
                                chapter: chapter,
                                name: "aaabbbbddddeeesssssdddd",
                                desc: "按时2321231313132131213按时2321231313132131213按时2321231313132131213",
                                curriculum_id: curriculum.id,
                                teacher_id: @teacher.id
                              }
                            }
      assert @teacher_session.redirect?
      @teacher_session.follow_redirect!
      @teacher_session.assert_template 'lessons/show'
    end
  end
end
