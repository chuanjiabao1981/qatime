module LiveService
  class ChatTeamManager
    def initialize(team)
      @team = team
    end

    # 创建聊天群组
    # 创建群组，默认不需要用户同意、不允许任何人申请加入
    def instance_team(course, teacher_account = nil)
      if course.chat_team
        @team = course.chat_team
        return @team
      end
      teacher_account = course.teacher.chat_account
      teacher_account ||= LiveService::ChatAccountFromUser.new(course.teacher).instance_account
      team_id = Chat::IM.team_create(tname: "#{course.name} 讨论组", owner: teacher_account.accid, members: [], msg: "#{course.name} 讨论组")
      @team = Chat::Team.create(team_id: team_id, owner: teacher_account.accid, name: "#{course.name} 讨论组", live_studio_course: course)
    end

    def remove_members(user_ids)
      Chat::Account.where(user_id: user_ids).find_each do |account|
        Chat::IM.team_kick(@team.team_id, @team.owner, account.accid)
      end
    end

    # 拉入群组
    def add_to_team(members, role, remote = true)
      members = members.to_a.compact
      current_members = @team.join_records.map(&:account_id)
      members.delete_if {|m| current_members.include?(m.id)}
      @course = @team.live_studio_course
      Chat::IM.team_add(@team.team_id, @team.owner, "#{@course.name} 讨论组", members) if remote
      members.each do |member|
        Chat::JoinRecord.create(team_id: @team.id, account_id: member.id, role: role)
      end
    end
  end
end
