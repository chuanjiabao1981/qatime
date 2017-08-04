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
      unless @chat_team && @chat_team.team_id.present?
        @chat_team = LiveService::ChatTeamManager.new(@chat_team).instance_team(@course, @course.teacher.chat_account)
      end
      # 当前用户没有加入群组立即加入群组
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id)
      @join_record ||= LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal')
      render json: { team_id: @chat_team.team_id, token: @chat_account.token, accid: @chat_account.accid, owner: @chat_team.owner }
    end

    # 返回群成员列表
    def members
      chat_team = Chat::Team.find_by(team_id: params[:id])
      @accounts = chat_team.accounts.includes(:user).to_a if chat_team

      if @accounts.present?
        owner = Account.find_by(accid: chat_team.owner)
        members = Chat::Team.online_members(chat_team.team_id)
        @online_accounts = Account.where(accid: members).to_a
        @token = Digest::MD5.hexdigest(members.join) if members.present?
        # 老师排第一 在线学生和不在线学生依次按name排序
        @accounts = @accounts - @online_accounts.to_a
        @accounts = @online_accounts.sort_by(&:name) + @accounts.sort_by(&:name)
        @accounts = @accounts.reject{|a| a == owner }.unshift(owner)
        @accounts = @accounts.select{|account| account.user.present?}
      end
      render partial: 'live_studio/courses/members'
    end

    # 成员访问群组
    # 如果在线成员发生变化,则返回 members
    def member_visit
      team_id = params[:id]
      acc_id = params[:acc_id]
      token = params[:token]
      Chat::Team.cache_member_visit(team_id, acc_id)
      @members = Chat::Team.online_members(team_id, token)
      if token == Chat::Team.token(team_id)
        render text: 'nothing'
      else
        redirect_to action: :members
      end
    end

    def status
      @team = Chat::Team.find_by!(team_id: params[:id])
      @course = @team.discussable
      @realtime_service =
        case @course
        when LiveStudio::Course
          LiveService::RealtimeService.new(@course.id)
        when LiveStudio::InteractiveCourse
          LiveService::InteractiveRealtimeService.new(@course.id)
        end
      render json: @realtime_service.live_detail(current_user.id)
    end

    def list
      @team = Chat::Team.find_by!(team_id: params[:id])
      render json: @team.members_json
    end
  end
end
