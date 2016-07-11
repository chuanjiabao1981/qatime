module LiveService
  class CourseDirector
    def initialize(course)
      @course = course
    end

    # 初始化辅导班所需实体
    def instance_for_course
      # 初始化直播推拉流
      instance_studio
      teacher = @course.teacher
      teacher_account = teacher.chat_account
      # 检查教师云信ID
      teacher_account ||= instance_account(teacher)
      user_ids = @course.tickets.map(&:student_id)
      members = Chat::Account.where(id: user_ids)
      # 初始化聊天群组
      instance_team_and_members(teacher_account, members)
    end

    # 辅导播放班授权
    def authorize_for_course(lesson)
    end

    # 发放听课证
    def deliver_ticket
    end

    private

    def instance_studio
    end

    # 初始化聊天群组，并且初始化群员
    def instance_team_and_members(teacher_account, members)
      team_manager = LiveService::ChatTeamManager.new(nil)
      team_manager.instance_team(@course, teacher_account)
      team_manager.add_to_team([teacher_account], 'owner', false) # 教师最为owner加入群组
      team_manager.add_to_team(members, 'normal') # 加入现有学生进入群组
    end

    def instance_account(user)
      LiveService::ChatAccountFromUser.new(user).instance_account
    end
  end
end
