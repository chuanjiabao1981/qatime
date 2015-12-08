module QaCommonStateUpdateParent
  extend ActiveSupport::Concern

  class_methods do
    def __update_parent_state_machine_after_create(parent,event= :handle)
      define_method :__update_parent_state_machine do
        ## 以solution为例子
        ## 因为只在on create调用,所以solution的last_operator和examination的last_operator相同
        send(parent).update_attributes(last_operator_id: self.last_operator_id,state_event: event)
      end
      after_create :__update_parent_state_machine
    end
  end

end

module QaCommonState
  extend ActiveSupport::Concern
  include QaCommonStateUpdateParent
  class_methods do

    def __create_state_machine(completed_validation=nil,parent=nil)
      include QaCustomizedCourseStateChangeRecord
      state_machine :state, initial: :new do
        transition :in_progress          => :completed,         :on => [:complete]
        transition :completed            => :in_progress,       :on => [:redo]
        transition :new                  => :completed,         :on => [:complete]

        before_transition :new => :in_progress,  :do => :set_first_handled_at
        before_transition any  => :completed,    :do => :set_completed_at
        before_transition :on  => :handle,       :do => :set_last_handled_at
        before_transition :on  => :redo,         :do => :set_last_redone_at
        event :handle do
          # 这里不排除completed主要是考虑到如果老师关闭了solution，但是学生还是可以继续提交作业的
          transition any  => :in_progress
        end

        if not completed_validation.nil?
          state :completed do
            validates_with completed_validation
          end
        end
        #例如，当execution处于completed状态，execution下的solution也处于completed状态，此时
        #solution修改状态为in_progress,则execution的状态也必须为in_progress状态
        if not parent.nil?
          after_transition any - :new => :in_progress do |state_object,transition|
            p = state_object.send(parent)
            if p.completed?
              p.last_operator  = state_object.last_operator
              p.state_event    = :redo
              p.save
            end
          end
        end

        after_transition do |state_object,transition|
          # 因为handle都有专门的对象，所以不需要记录这个事件的状态
          # correction的创建对应solutions的handle
          # solution的撞见对应examination的handle
          if transition.event != :handle
            # puts "...........+#{transition.event}"
            a = state_object.customized_course_state_change_records.build(
                name: :state_change,
                from: transition.from,
                to: transition.to,
                event: transition.event,
                operator_id: state_object.last_operator.id
            )
            a.save
          end
        end
      end

      if not parent.nil?
        __update_parent_state_machine_after_create(parent)
        # define_method :__update_parent_first_handle do
        #   ## 以solution为例子
        #   ## 因为只在on create调用,所以solution的last_operator和examination的last_operator相同
        #   send(parent).update_attributes(last_operator_id: self.last_operator_id,state_event: :handle)
        # end
        # after_create :__update_parent_first_handle
      end
    end
  end

  def set_last_redone_at
    self.last_redone_at = DateTime.now
  end
  def set_last_handled_at
    self.last_handled_at = DateTime.now
  end
  def set_first_handled_at
    self.first_handled_at = DateTime.now
  end
  def set_completed_at
    self.completed_at     = DateTime.now
  end
end