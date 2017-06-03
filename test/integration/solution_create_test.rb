require 'test_helper'
require 'content_input_helper'

class SolutionCreateTest < ActionDispatch::IntegrationTest
  include ContentInputHelper

  def setup
    @headless               = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @student                = users(:student1)
    @homework               = examinations(:homework1)
    @exercise               = examinations(:exercise_one)
    log_in_as(@student)
  end

  def teardown
    new_logout_as(@student)
    Capybara.use_default_driver
  end


  test 'create with picture' do
    _create_with_picture(@homework,HomeworkSolution)
    _create_with_picture(@exercise,ExerciseSolution)
  end





  def _create_with_picture(e,s)
    new_path      = send("new_#{e.model_name.singular_route_key}_#{e.model_name.singular_route_key}_solution_path",e)

    visit new_path
    assert_difference "Picture.where(imageable_type: \"#{Solution.to_s}\").count",1 do
      assert_difference "Picture.where(imageable_type: \"#{s.to_s}\").count",0 do
        fill_in "#{s.model_name.singular_route_key}_title",with: '这个长度不能少10的啊啊啊aaaaa'
        set_content "asdfadfasdf"
        add_a_picture
        click_on "新增#{s.model_name.human}"
        sleep 1
        new_solution    = s.all.order(:created_at => :desc).first
        new_picture     = Picture.where(imageable_type: "#{Solution.to_s}").order(:created_at => :desc).first
        new_solution.pictures.include?(new_picture)
        page.save_screenshot('screenshots/screenshot.png')
        assert_picture(new_solution)
      end
    end
  end
end
