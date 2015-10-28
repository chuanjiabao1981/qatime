require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class WorkstationIntegrateTest < LoginTestBase
  self.use_transactional_fixtures = true

  def setup
    @admin            = Admin.find(users(:admin).id)
    @admin_session    = log_in2_as(@admin)
    @manager          = Manager.find(users(:manager).id)
    @manager_session  = log_in2_as(@manager)
  end

  test 'list page' do
    @admin_session.get admins_workstations_path(@admin)
    @admin_session.assert_select "a[href=?]", new_admins_workstation_path,count:1
  end

  test 'new page' do
    new_page(@admin,@admin_session,new_admins_workstation_path)
    new_page(@manager,@manager_session,new_admins_workstation_path)
  end

  test 'create page' do

  end

  test 'edit page' do

  end

  test 'update page' do
  end

  test 'show page' do
  end

  def new_page(user,user_session,new_path)
    user_session.get new_path
    if not user.admin?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select "form[action=?]",admins_workstations_path,1
    # 应该有一个管理员
    user_session.assert_select "select[id=?]","workstation_manager_id", 1
    # 应该有一个城市
    user_session.assert_select "select[id=?]","workstation_city_id", 1
    user_session.assert_select "option", 4
  end

  def create_page(user,user_session,create_path)

  end

  def teardown
    @admin             = nil
    @manager           = nil
    log_out2(@admin_session)
    log_out2(@manager_session)
    @admin_session     = nil
    @manager_session   = nil
  end

end