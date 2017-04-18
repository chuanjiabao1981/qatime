require 'test_helper'

module LiveStudio
  class ManagerVideoCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager view video course list" do
      click_on "视频课"
      assert page.has_link?('视频课列表')
      assert page.has_link?('发行/销售')
      assert page.has_link?('视频课审核')

      click_on "视频课列表", match: :first
      assert page.has_content?('销售分成')
      assert page.has_content?('二维码')
      assert page.has_button?('生成'), "没有二维码生成按钮"
      assert page.has_select?('q_workstation_id_eq')
      assert page.has_select?('q_subject_eq')
      assert page.has_select?('q_grade_eq')

      select '高二', from: 'q_grade_eq'
      assert page.has_content? '高二'
      assert_equal page.all('.admin-list-con table tr').size, 3

      page.first(:css, 'input.send_qa_code').click
    end

    test "manager view video course my_publish" do
      click_on "视频课"
      click_on "发行/销售"
      assert page.has_link?('我的发行')
      assert page.has_link?('我的销售')
      assert page.has_content?('视频课名称')
      assert page.has_content?('老师分成')
      assert page.has_content?('发行分成')
      assert page.has_content?('购买人数')
      click_on '我的销售'

      assert page.has_content?('销售分成')
      assert page.has_content?('平台分成')
    end

    test "manager view video course audits" do
      click_on "视频课"
      click_on '视频课审核'
      assert page.has_link?('已审核')
      assert page.has_link?('未审核')
      assert page.has_content?('课时数')
      assert page.has_content?('视频总长')
      assert page.has_content?('审核')
      assert_equal LiveStudio::VideoCourse.no_audit.count + 1, page.all('.admin-list-con table tr').size
      assert page.has_link?('播放')
      assert page.has_link?('通过')
      assert page.has_link?('驳回')

      click_on '已审核'
      assert_equal LiveStudio::VideoCourse.audited.count + 1, page.all('.admin-list-con table tr').size
      click_on '未审核'
      message = accept_prompt(with: '确定审核通过么?') do
        click_on '通过', match: :first
      end
      assert_equal page.all('.admin-list-con table tr').size, 2
      message2 = accept_prompt(with: '确定驳回么?') do
        click_on '驳回', match: :first
      end
      assert_equal page.all('.admin-list-con table tr').size, 1
      click_on '已审核'
      assert_equal page.all('.admin-list-con table tr').size, 3
      assert page.has_content?('审核视频课1')
      assert page.has_content?('审核结果')
      assert page.has_content?('已通过')
      assert page.has_content?('已驳回')
    end

  end
end
