require 'test_helper'


class CoursesTest < LoginTestBase

  def setup
    super
  end

  test 'course new' do
    assert false
  end
  test 'course create' do
    curriculum    = @teacher.curriculums.first
    chapter       =  curriculum.teaching_program.content["chapters"][0]
    assert_difference 'Course.count',1 do

      @teacher_session.post teachers_curriculum_courses_path(@teacher.curriculums.first),
                          course:{chapter: chapter,
                                  name: "aaabbbbddddeeesssssdddd",
                                  desc: "按时2321231313132131213按时2321231313132131213按时2321231313132131213",
                                  curriculum_id: curriculum.id,
                                  teacher_id: @teacher.id
                                  }
      assert @teacher_session.redirect?
      @teacher_session.follow_redirect!
      @teacher_session.assert_template 'lessons/show'
    end
  end
end