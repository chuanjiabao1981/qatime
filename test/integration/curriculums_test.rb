require 'test_helper'

class CurriculumsTest < LoginTestBase
  def setup
    super
    @curriculum = curriculums(:teacher1_math_curriculum)
  end

  test "teacher edit courses position" do
    @teacher_session.get edit_courses_position_teachers_curriculum_path(@curriculum)
    @teacher_session.assert_template 'teachers/curriculums/edit_courses_position'
    @teacher_session.assert_select 'form'
    @teacher_session.assert_template layout: "layouts/application"
    @teacher_session.assert_response :success
  end

  test "teacher update course position" do
    t = {}
    @curriculum.courses.each_with_index do |c, i|
      p = {}
      p["position"] = i.to_s
      p["id"]       = c.id.to_s
      t[i.to_s]     = p
    end
    @teacher_session.put teachers_curriculum_path(@curriculum), params: { curriculum: { courses_attributes: t } }
    assert @teacher_session.redirect?
    @teacher_session.follow_redirect!
    @teacher_session.assert_template 'curriculums/show'
  end
end
