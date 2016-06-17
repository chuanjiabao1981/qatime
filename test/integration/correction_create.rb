require 'content_input_helper'

class CorrectionWithVideoTest < ActionDispatch::IntegrationTest
  include ContentInputHelper

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver           =  :selenium_chrome
    @teacher                          =  users(:teacher1)
    @homework_solution                =  solutions(:homework_solution_one)
    @exercise_solution                =  solutions(:exercise_solution_one)
    log_in_as(@teacher)

  end

  def teardown
    logout_as(@teacher)
    Capybara.use_default_driver
  end

  test 'create correction' do
    _create_with_picture_and_video(@homework_solution,HomeworkCorrection)
    _create_with_picture_and_video(@exercise_solution,ExerciseCorrection)
  end

  def _create_with_picture_and_video(solution,correction)
    show_path = send "#{solution.model_name.singular_route_key}_path",solution
    visit show_path
    page.save_screenshot('screenshots/screenshot.png')

    assert_difference "#{correction.to_s}.count",1 do
      assert_difference "Video.where(videoable_type: \"#{Correction.to_s}\").count",1 do
        assert_difference "Picture.where(imageable_type: \"#{Correction.to_s}\").count",1 do
          assert_difference "Video.where(videoable_type: \"#{correction.to_s}\").count",0 do
            assert_difference "Picture.where(imageable_type: \"#{correction.to_s}\").count",0 do
              set_all_possible_info random_str
              click_on "新增#{correction.model_name.human}"
              sleep 1
              new_correction = correction.all.order(created_at: :desc).first
              assert_picture new_correction
              assert_video new_correction
            end
          end
        end
      end
    end
  end


end
