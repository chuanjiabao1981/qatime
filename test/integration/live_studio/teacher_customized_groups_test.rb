require 'test_helper'

module LiveStudio
  # 我的专属课测试
  class TeacherCustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher1)
      new_log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "visit teacher customized group page" do
      visit live_studio.teacher_customized_groups_path(@teacher)
      assert page.has_content? '我的专属课'
      assert page.has_link? '全部'
      assert page.has_link? '招生中'
      assert page.has_link? '开课中'
      assert page.has_link? '已结束'
      click_on '招生中'
      assert page.has_content? '发布的专属课1'

      click_on '已结束'
      assert page.has_content? '结束的专属课1'
    end

    test "teacher manage customized group files" do
      group = live_studio_groups(:published_group1)
      visit live_studio.customized_group_path(group)

      find("a[href='#courseware']").click
      assert page.has_link?('新增课件')
      click_link '新增课件'
      assert page.has_content?('选择新增课件来源')
      click_link '提交'
      assert page.has_content?('请添加文件')
      attach_file("lefile", "#{Rails.root}/test/integration/test.mp4", visible: false)
      sleep(1)
      assert find(:css, '#load_files').has_content?('test.mp4')
      assert find(:css, '#load_files').has_link?('删除')
      assert_difference "Resource::Quote.count", 2, "老师和课程的引用创建失败" do
        click_link '提交'
      end

      sleep(1)
      find("a[href='#courseware']").click
      assert page.has_content?('test.mp4')
      assert page.has_link?('下载')
      assert page.has_link?('删除')
      assert_difference "Resource::Quote.count", -1, "课程引用删除失败" do
        find(:css, 'a.delete_quote', match: :first).click
        sleep(2)
      end

      click_link '新增课件'
      find("a[data-target='#selectMyFiles']").click
      find(:css, '.my_file_checkbox', match: :first).set(true)
      click_link '确定'
      sleep(1)
      assert find(:css, '#load_files').has_link?('删除')
      assert_difference "Resource::Quote.count", 1, "老师和课程的引用创建失败" do
        click_link '提交'
        sleep(1)
      end
    end

    test "teacher visit my files page" do
      visit resource.teacher_files_path(@teacher)
      assert page.has_content?('我的文件')
      assert page.has_link?('添加新文件')
      assert page.has_link?('视频')
      assert page.has_link?('图片')
      assert page.has_link?('文档')

      click_link '添加新文件'
      assert page.has_content?('已选择文件(0)')
      attach_file("lefile", "#{Rails.root}/test/integration/test.mp4", visible: false)
      assert page.has_content?('已选择文件(1)')
      sleep(1)
      assert find(:css, '#load_files').has_content?('test.mp4')
      assert find(:css, '#load_files').has_link?('删除')
      assert_difference "Resource::Quote.count", 1, "老师的引用创建失败" do
        click_link '提交并添加'
        sleep(1)
      end

      assert page.has_content?('test.mp4')
      assert page.has_link?('下载')
      assert page.has_link?('删除')

      assert_difference "Resource::Quote.count", -1, "老师的引用删除失败" do
        message = accept_prompt(with: '确定删除么?') do
          click_link '删除', match: :first
        end
        sleep(1)
      end
    end
  end
end
