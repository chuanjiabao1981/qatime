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
      # 检查教师云信ID
      instance_account(teacher) unless teacher.chat_account
      user_ids = @course.tickets.map(&:student_id)
      members = Chat::Account.where(id: user_ids)
      # 初始化聊天群组
      instance_team(teacher.chat_account, members)
    end

    # 辅导班授权
    def authorize_for_course(lesson)
    end

    # 发放听课证
    def deliver_ticket
    end

    private

    def instance_studio
    end

    def instance_team(owner, members)
      # 创建群组，默认不需要用户同意、不允许任何人申请加入
      team_id = Chat::IM.team_create(tname: "#{@course.name} 讨论组", owner: owner.accid, members: [], msg: "#{@course.name} 讨论组")
      Chat::Team.create(team_id: team_id, name: "#{@couse.name} 讨论组", live_studio_course: @course)
    end

    def add_to_team(team, members, remote=false)
      # TODO
      Chat::IM.team_add(team.team_id, "cwheart", "#{@course.name} 讨论组", members) if remote
      members.each do |memeber|
        Chat::JoinRecord.create(team_id: team.id, account_id: member.id)
      end
    end

    def instance_account(user)
      LiveService::ChatAccountFromUser.new(user).set_chat_account
    end
  end
end
