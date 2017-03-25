require 'tools'

module LiveService
  class ChatTeamManager
    def initialize(team)
      @team = team
    end

    # 创建聊天群组
    # 创建群组，默认不需要用户同意、不允许任何人申请加入
    def instance_team(course, teacher_account = nil)
      teacher_account ||= find_or_instance_account(course.teacher)
      @team = find_or_create_chat_team(course, teacher_account)
      Tools.with_log("course-#{course.id}-team-create", 30) do
        @team.team_id = Chat::IM.team_create(tname: @team.name, owner: @team.owner, members: [], msg: "#{course.name} 讨论组")
        @team.save
      end unless @team.team_id
      @team
    end

    def remove_members(user_ids)
      account_ids = Chat::Account.where(user_id: user_ids).find_each do |account|
        Chat::IM.team_kick(@team.team_id, @team.owner, account.accid)
      end
      @team.join_records.where(account_id: account_ids).destroy_all
    end

    # 拉入群组
    def add_to_team(members, role, remote = true)
      members = members.to_a.compact
      current_members = @team.join_records.map(&:account_id)
      members.delete_if {|m| current_members.include?(m.id)}
      @course = @team.live_studio_course

      Chat::IM.team_add(@team.team_id, @team.owner, "#{@course.name} 讨论组", members.map(&:accid)) if remote
      members.map do |member|
        Chat::JoinRecord.create(team_id: @team.id, account_id: member.id, role: role, nick_name: member.name)
      end
    end

    private

    def find_or_instance_account(user)
      return user.chat_account if user.chat_account
      LiveService::ChatAccountFromUser.new(user).instance_account
    end

    def find_or_create_chat_team(course, teacher_account)
      return course.chat_team if course.chat_team
      Chat::Team.create(owner: teacher_account.accid, name: "#{course.name} 讨论组", live_studio_course: course)
    rescue ActiveRecord::RecordNotUnique
      course.reload
      retry
    end
  end
end
