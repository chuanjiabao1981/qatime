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
    @workstation = workstations(:workstation1)
  end

  test 'list page' do
    @admin_session.get admins_workstations_path(@admin)
    @admin_session.assert_select "a[href=?]", new_admins_workstation_path,count:1
  end

  test 'new page' do
    new_page(@admin, @admin_session,new_admins_workstation_path)
    new_page(@manager, @manager_session,new_admins_workstation_path)
  end

  test 'show page' do
    show_page(@admin, @admin_session, station_workstation_path(@workstation))
    show_page(@manager, @manager_session, admins_workstation_path(@workstation))
  end

  def new_page(user,user_session,new_path)
    user_session.get new_path
    if not user.admin?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select "form[action=?]",admins_workstations_path,1
    user_session.assert_select "option", 12
  end

  def show_page(user, user_session, show_path)
    user_session.get show_path
    if user.admin?
      user_session.assert_response :success
    else
      user_session.assert_redirected_to managers_home_path
    end
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
