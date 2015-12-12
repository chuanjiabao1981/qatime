module QaCommonStateTest
  def check_state_change_link(user,user_session,state_object,use_super_controller)
    state_object.state_events.each do |x|
      state_change_url  = 0
      if user.teacher?
        if x != :handle
          state_change_url = 1
        end
      end
    user_session.assert_select 'a[href=?]',send("#{x}_#{state_object.model_name.singular_route_key}_path",state_object,use_super_controller: use_super_controller),state_change_url
    end
  end
end