module QaCustomizedCourse
  extend ActiveSupport::Concern

  def customized_course_associations_prepare
    unless not @workstations.nil?
      # 编辑
      if not @customized_course.nil?
        # 如果creator为admin，则返回所有的工作站
        if @customized_course.creator.admin?
          @workstations = Workstation.all
        # 否则
        else
          @workstations = Workstation.by_manager_id(get_manager_id(@customized_course.creator_id))
        end
      else
        # 新建
        # 如果当前用户为admin，则返回所有的工作站
        if current_user.admin?
          @workstations = Workstation.all
        #否则，得到经理对应的工作站
        elsif current_user.manager?
          @workstations = Workstation.by_manager_id(get_manager_id(current_user.id))
        else
          @workstations = [current_user.workstation]
        end
      end
    end
  end

  private

  def get_manager_id(creator_id)
    # creator的类型比较多，有销售、工作人员、经理，因此需要从creator里面获取对应的经理，再去关联workstation
    # 目前创建者只有admin、manager
    creator_id
  end
end
