class WorkstationEarningRecordsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    new_logout_as(@login_user) if @login_user
    Capybara.use_default_driver
  end

  test "manager view earning_records" do
    @login_user = users(:manager_zhuji)
    log_in_as(@login_user)
    click_on '收入记录'
    assert page.has_content?(LiveStudio::Course.model_name.human), '辅导班收入未显示'
    assert page.has_content?(CustomizedTutorial.model_name.human), '专属课程收入未显示'
    assert page.has_content?(Correction.model_name.human), "#{Correction.model_name.human}收入未显示"
    assert page.has_content?(CourseIssueReply.model_name.human), "#{CourseIssueReply.model_name.human}收入未显示"
    assert page.has_content?("共计 ￥ 105.0"), "总收入显示不正确"
    fill_in :q, with: "15910676001"
    click_on "查询"
    select('最近1周', from: 'category')
    click_on "查询"
    assert page.has_content?("共计 ￥ 55.0"), "最近一周过滤后总收入显示不正确"
  end
end
