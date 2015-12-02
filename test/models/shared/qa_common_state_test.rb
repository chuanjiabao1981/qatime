module QaCommonStateTest

  def check_first_handle_timestamp(state_object,&block)
    assert state_object.state    == "new"
    assert state_object.first_handled_at.nil?
    assert state_object.last_handled_at.nil?
    yield state_object
    assert state_object.valid?,state_object.errors.full_messages
    assert_not state_object.reload.first_handled_at.nil?
    assert_not state_object.reload.last_handled_at.nil?
    assert     state_object.completed_at.nil?
  end
  def check_state_timestamp(state_object)
    assert state_object.state    == "new"
    assert state_object.first_handled_at.nil?
    assert state_object.last_handled_at.nil?
    state_object.state_event     = :handle
    state_object.save
    assert state_object.valid?,state_object.errors.full_messages
    assert_not state_object.reload.first_handled_at.nil?
    assert_not state_object.reload.last_handled_at.nil?
    assert     state_object.completed_at.nil?

    state_object.state_event    = :complete
    assert state_object.valid?,state_object.errors.full_messages
    state_object.save
    assert state_object.reload.state   == "completed",state_object.state
    assert_not state_object.completed_at.nil?


    ## completed之后继续处理
    state_object.state_event    = :handle
    state_object.save
    state_object.reload
    assert state_object.last_handled_at.to_f > state_object.first_handled_at.to_f

    ## 记录redo时间
    assert state_object.last_redone_at.nil?
    state_object.state_event       = :complete
    state_object.save
    state_object.state_event    = :redo
    state_object.save
    assert_not state_object.last_redone_at.nil?
  end

  def check_state_change_record(state_object)
    state_object.state                      = :in_progress
    teacher1                                = users(:teacher1)
    state_object.last_operator              = teacher1
    state_object.state_event                = :complete
    assert_difference 'CustomizedCourseStateChangeRecord.count',1 do
      assert_difference 'CustomizedCourseActionNotification.count',2 do
        state_object.save
      end
    end

    a = CustomizedCourseStateChangeRecord.all.order(:created_at => :desc).first
    assert a.operator.id           == teacher1.id
    assert a.actionable            == state_object
    a.desc
  end
end