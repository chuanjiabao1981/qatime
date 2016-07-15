require_dependency "chat/application_controller"

module Chat
  class TeamsController < ApplicationController
    def finish
      @course = LiveStudio::Course.find(params[:live_studio_course_id])
      # 当前用户没有云信ID创建云信ID
      @chat_account = current_user.chat_account
      @chat_account ||= LiveService::ChatAccountFromUser.new(current_user).instance_account
      # 如果没有team创建team
      @chat_team = @course.chat_team
      @chat_team ||= LiveService::ChatTeamManager.new(@chat_team).instance_team(@course, @course.teacher.chat_account)
      # 当前用户没有加入群组立即加入群组
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id)
      @join_record ||= LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal')
      render json: { team_id: @chat_team.team_id, token: @chat_account.token, accid: @chat_account.accid }
    end

    # 返回群成员列表
    def members
      chat_team = Chat::Team.find_by(team_id: params[:live_studio_course_id])
      @accounts = chat_team.try(:accounts).to_a

      if !@accounts.blank?
        owner = Account.find_by(accid: chat_team.owner)
        members = params[:members].try(:split,',')
        @online_accounts = Account.where(accid: members).to_a
        # 老师一定online,但不能重复
        @online_accounts << owner
        @online_accounts.uniq!
        @token = Digest::MD5.hexdigest(members.join) if members.present?
        # 老师排第一 在线学生和不在线学生依次按name排序
        @accounts = @accounts - @online_accounts.to_a
        @accounts = @online_accounts.sort_by(&:name) + @accounts.sort_by(&:name)
        @accounts = @accounts.reject{|a| a == owner }.unshift(owner)
      end
      render partial: 'live_studio/courses/members'
    end

    # 成员访问群组
    # 如果在线成员发生变化,则返回 members
    def member_visit
      team_id = params[:live_studio_course_id]
      acc_id = params[:acc_id]
      token = params[:token]
      Chat::Team.cache_member_visit(team_id,acc_id)
      @members = Chat::Team.online_members(team_id, token)
      if token == Digest::MD5.hexdigest(@members.join)
        render text: 'nothing'
      else
        redirect_to action: :members, members: @members.uniq.compact.join(',')
      end
    end
  end
end
