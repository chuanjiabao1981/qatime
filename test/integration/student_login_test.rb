require 'test_helper'

class StudentLoginTest< ActionDispatch::IntegrationTest

  test 'login' do
    student1 = users(:student1)
    log_in_as(student1)
    assert page.has_content? Curriculum.model_name.human
    click_on Curriculum.model_name.human
  end
end