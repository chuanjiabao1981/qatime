require 'test_helper'

class StudentHomeTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @student = users(:student1)
    log_in_as(@student)
  end

  def teardown
    new_logout_as(@student)
    Capybara.use_default_driver
  end

  test "student teachers page" do
    visit teachers_student_path(@student)
    assert page.has_content? '我的老师'
    assert page.all('ul.tec-list li').size, @student.learning_plans.count

    plan = @student.learning_plans.first
    assert page.has_link?(nil, href: vip_class_path(plan.vip_class))
  end

end
