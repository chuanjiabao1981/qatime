require 'test_helper'
require 'tally_test_helper'

class CustomizedCourseAATest < ActiveSupport::TestCase
  include TallyTestHelper

  test "validate customize course" do
    manager = users(:manager)
    workstation = Workstation.by_manager_id(manager.id).first

    cc = customized_courses(:customized_course1)
    assert cc.valid?
    assert cc.teachers.size == 2 , cc.teachers.size

    student = Student.find(users(:student1).id)

    APP_CONSTANT["categories"].each do |category|
      APP_CONSTANT["subjects"].each do |subject|
        cc = student.customized_courses.build
        cc.category = category
        cc.subject = subject
        cc.creator_id = manager.id
        cc.workstation_id = workstation.id
        assert cc.save
        assert cc.valid?

        teacher_price_expected, platform_price_expected = get_expected_customized_course_prices(cc)
        assert cc.platform_price == platform_price_expected
        assert cc.teacher_price == teacher_price_expected
      end
    end

    # For customize course, if we update the subject and category, the corresponding prices must be update automatically
    # By default, the customized_course_type is heighten
    cc = student.customized_courses.build
    cc.category = "高中"
    cc.subject  = "数学"
    cc.creator_id = manager.id
    cc.workstation_id = workstation.id
    cc.save
    teacher_price_old, platform_price_old = get_expected_customized_course_prices(cc)
    cc.spurt!
    teacher_price_new, platform_price_new = get_expected_customized_course_prices(cc)
    assert_not_equal teacher_price_old, teacher_price_new
  end

  test "timeout_to_solve_home" do
    cc = customized_courses(:customized_course3)
    assert cc.valid?
    assert cc.homeworks.first.valid?
    assert cc.timeout_to_solve_homeworks.count == 1
  end

end
